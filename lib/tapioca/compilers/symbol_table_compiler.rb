# typed: strict
# frozen_string_literal: true

require "pathname"

module Tapioca
  module Compilers
    class SymbolTableCompiler
      extend T::Sig
      include Reflection

      class Event; end

      class SymbolEvent < Event
        extend T::Sig

        sig { returns(String) }
        attr_reader :symbol

        sig { params(symbol: String).void }
        def initialize(symbol)
          @symbol = symbol
        end
      end

      class ConstantEvent < Event
        extend T::Sig

        sig { returns(String) }
        attr_reader :symbol

        sig { returns(BasicObject).checked(:never) }
        attr_reader :constant

        sig { params(symbol: String, constant: BasicObject).void.checked(:never) }
        def initialize(symbol, constant)
          @symbol = symbol
          @constant = constant
        end
      end

      class NodeEvent < Event
        extend T::Sig
        extend T::Helpers

        abstract!

        sig { returns(String) }
        attr_reader :symbol

        sig { returns(Module).checked(:never) }
        attr_reader :constant

        sig { params(symbol: String, constant: Module).void.checked(:never) }
        def initialize(symbol, constant)
          @symbol = symbol
          @constant = constant
        end
      end

      class ConstEvent < NodeEvent
        extend T::Sig

        sig { returns(RBI::Const) }
        attr_reader :const

        sig { params(symbol: String, constant: Module, const: RBI::Const).void.checked(:never) }
        def initialize(symbol, constant, const)
          super(symbol, constant)
          @const = const
        end
      end

      class ScopeEvent < NodeEvent
        extend T::Sig

        sig { returns(RBI::Scope) }
        attr_reader :scope

        sig { params(symbol: String, constant: Module, scope: RBI::Scope).void.checked(:never) }
        def initialize(symbol, constant, scope)
          super(symbol, constant)
          @scope = scope
        end
      end

      class MethodEvent < NodeEvent
        extend T::Sig

        sig { returns(RBI::Method) }
        attr_reader :node

        sig { returns(T.untyped) }
        attr_reader :signature

        sig { returns(T::Array[[Symbol, String]]) }
        attr_reader :parameters

        sig do
          params(
            symbol: String,
            constant: BasicObject,
            node: RBI::Method,
            signature: T.untyped,
            parameters: T::Array[[Symbol, String]]
          ).void.checked(:never)
        end
        def initialize(symbol, constant, node, signature, parameters)
          super(symbol, constant)
          @node = node
          @signature = signature
          @parameters = parameters
        end
      end

      IGNORED_SYMBOLS = T.let(["YAML", "MiniTest", "Mutex"], T::Array[String])

      sig { params(gem: Gemfile::GemSpec, include_doc: T::Boolean).void }
      def initialize(gem, include_doc: false)
        @gem = gem
        @seen = T.let(Set.new, T::Set[String])
        @alias_namespace = T.let(Set.new, T::Set[String])

        @payload_symbols = T.let(SymbolLoader.payload_symbols, T::Set[String])
        @bootstrap_symbols = T.let(SymbolLoader.gem_symbols(@gem).union(SymbolLoader.engine_symbols), T::Set[String])

        @events = T.let([], T::Array[Event])

        @node_listeners = T.let([], T::Array[NodeListeners::Base])
        @node_listeners << NodeListeners::Mixins.new(self)
        @node_listeners << NodeListeners::DynamicMixins.new(self)
        @node_listeners << NodeListeners::Helpers.new(self)
        @node_listeners << NodeListeners::Methods.new(self)
        @node_listeners << NodeListeners::Enums.new(self)
        @node_listeners << NodeListeners::Props.new(self)
        @node_listeners << NodeListeners::RequiresAncestor.new(self)
        @node_listeners << NodeListeners::Signatures.new(self)
        @node_listeners << NodeListeners::TypeVariables.new(self)
        @node_listeners << NodeListeners::YardDoc.new(self) if include_doc

        gem.parse_yard_docs if include_doc
      end

      sig { params(rbi: RBI::File).void }
      def compile(rbi)
        @root = T.let(rbi.root, T.nilable(RBI::Tree))
        @bootstrap_symbols.sort.each { |symbol| push_symbol(symbol) }
        dispatch_event(T.must(@events.shift)) until @events.empty?
        @root = nil
      end

      sig { params(symbol: String).void }
      def push_symbol(symbol)
        @events << SymbolEvent.new(symbol)
      end

      sig { params(symbol: String, constant: BasicObject).void.checked(:never) }
      def push_constant(symbol, constant)
        @events << ConstantEvent.new(symbol, constant)
      end

      sig { params(symbol: String, constant: Module, const: RBI::Const).void.checked(:never) }
      def push_const(symbol, constant, const)
        @events << ConstEvent.new(symbol, constant, const)
      end

      sig { params(symbol: String, constant: Module, scope: RBI::Scope).void.checked(:never) }
      def push_scope(symbol, constant, scope)
        @events << ScopeEvent.new(symbol, constant, scope)
      end

      sig do
        params(
          symbol: String,
          constant: BasicObject,
          node: RBI::Method,
          signature: T.untyped,
          parameters: T::Array[[Symbol, String]]
        ).void.checked(:never)
      end
      def push_method(symbol, constant, node, signature, parameters)
        @events << MethodEvent.new(symbol, constant, node, signature, parameters)
      end

      sig { params(sig_string: String).returns(String) }
      def sanitize_signature_types(sig_string)
        sig_string
          .gsub(".returns(<VOID>)", ".void")
          .gsub("<VOID>", "void")
          .gsub("<NOT-TYPED>", "T.untyped")
          .gsub(".params()", "")
      end

      # TODO: move
      sig { params(method: UnboundMethod).returns(T::Boolean) }
      def method_in_gem?(method)
        source_location = method.source_location&.first
        return false if source_location.nil?

        @gem.contains_path?(source_location)
      end

      # TODO: private
      sig { params(symbol_name: String).returns(T::Boolean) }
      def symbol_in_payload?(symbol_name)
        symbol_name = T.must(symbol_name[2..-1]) if symbol_name.start_with?("::")
        @payload_symbols.include?(symbol_name)
      end

      private

      # Events

      sig { params(event: Event).void }
      def dispatch_event(event)
        case event
        when SymbolEvent
          on_symbol(event)
        when ConstantEvent
          on_constant(event)
        when NodeEvent
          on_node(event)
        end
      end

      sig { params(event: SymbolEvent).void }
      def on_symbol(event)
        symbol = event.symbol
        return if symbol_in_payload?(symbol) && !@bootstrap_symbols.include?(symbol)
        constant = constantize(symbol)
        return unless constant

        push_constant(symbol, constant)
      end

      sig { params(event: ConstantEvent).void.checked(:never) }
      def on_constant(event)
        name = event.symbol

        return if name.strip.empty?
        return if name.start_with?("#<")
        return if name.downcase == name
        return if alias_namespaced?(name)
        return if seen?(name)

        constant = event.constant
        return if T::Enum === constant # T::Enum instances are defined via `compile_enums`

        mark_seen(name)

        compile_constant(name, constant)
      end

      sig { params(event: NodeEvent).void }
      def on_node(event)
        @node_listeners.each { |listener| listener.dispatch(event) }
      end

      # Compiling

      sig { params(name: String, constant: BasicObject).void.checked(:never) }
      def compile_constant(name, constant)
        case constant
        when Module
          if name_of(constant) != name
            compile_alias(name, constant)
          else
            compile_scope(name, constant)
          end
        else
          compile_object(name, constant)
        end
      end

      sig { params(name: String, constant: Module).void }
      def compile_alias(name, constant)
        return if symbol_in_payload?(name)

        target = name_of(constant)
        # If target has no name, let's make it an anonymous class or module with `Class.new` or `Module.new`
        target = "#{constant.class}.new" unless target

        add_to_alias_namespace(name)

        return if IGNORED_SYMBOLS.include?(name)

        node = RBI::Const.new(name, target)
        push_const(name,  constant, node)
        @root <<  node
      end

      sig { params(name: String, value: BasicObject).void.checked(:never) }
      def compile_object(name, value)
        return if symbol_in_payload?(name)

        klass = class_of(value)

        klass_name = if klass == ObjectSpace::WeakMap
          # WeakMap is an implicit generic with one type variable
          "ObjectSpace::WeakMap[T.untyped]"
        elsif T::Generic === klass
          generic_name_of(klass)
        else
          name_of(klass)
        end

        if klass_name == "T::Private::Types::TypeAlias"
          type_alias = sanitize_signature_types(T.unsafe(value).aliased_type.to_s)
          node = RBI::Const.new(name, "T.type_alias { #{type_alias} }")
          push_const(name,  klass, node)
          @root << node
          return
        end

        return if klass_name&.start_with?("T::Types::", "T::Private::")

        type_name = klass_name || "T.untyped"
        node = RBI::Const.new(name, "T.let(T.unsafe(nil), #{type_name})")
        push_const(name,  klass, node)
        @root << node
      end

      sig { params(name: String, constant: Module).void }
      def compile_scope(name, constant)
        return unless defined_in_gem?(constant, strict: false)
        return if Tapioca::TypeVariableModule === constant

        scope =
          if constant.is_a?(Class)
            superclass = compile_superclass(constant)
            RBI::Class.new(name, superclass_name: superclass)
          else
            RBI::Module.new(name)
          end

        # return if symbol_in_payload?(name) && scope.empty?

        push_scope(name,  constant, scope)
        @root << scope
        compile_subconstants(name, constant)
      end

      sig { params(constant: Class).returns(T.nilable(String)) }
      def compile_superclass(constant)
        superclass = T.let(nil, T.nilable(Class)) # rubocop:disable Lint/UselessAssignment

        while (superclass = superclass_of(constant))
          constant_name = name_of(constant)
          constant = superclass

          # Some types have "themselves" as their superclass
          # which can happen via:
          #
          # class A < Numeric; end
          # A = Class.new(A)
          # A.superclass #=> A
          #
          # We compare names here to make sure we skip those
          # superclass instances and walk up the chain.
          #
          # The name comparison is against the name of the constant
          # resolved from the name of the superclass, since
          # this is also possible:
          #
          # B = Class.new
          # class A < B; end
          # B = A
          # A.superclass.name #=> "B"
          # B #=> A
          superclass_name = name_of(superclass)
          next unless superclass_name

          resolved_superclass = constantize(superclass_name)
          next unless Module === resolved_superclass
          next if name_of(resolved_superclass) == constant_name

          # We found a suitable superclass
          break
        end

        return if superclass == ::Object || superclass == ::Delegator
        return if superclass.nil?

        name = name_of(superclass)
        return if name.nil? || name.empty?

        push_symbol(name)

        "::#{name}"
      end

      sig { params(name: String, constant: Module).void }
      def compile_subconstants(name, constant)
        constants_of(constant).sort.uniq.map do |constant_name|
          symbol = (name == "Object" ? "" : name) + "::#{constant_name}"
          subconstant = constantize(symbol)

          # Don't compile modules of Object because Object::Foo == Foo
          # Don't compile modules of BasicObject because BasicObject::BasicObject == BasicObject
          next if (Object == constant || BasicObject == constant) && Module === subconstant

          push_constant(symbol, subconstant) if subconstant
        end
      end

      # Helpers

      sig { params(constant: Module, strict: T::Boolean).returns(T::Boolean) }
      def defined_in_gem?(constant, strict: true)
        files = Set.new(get_file_candidates(constant))
          .merge(Tapioca::Trackers::ConstantDefinition.files_for(constant))

        return !strict if files.empty?

        files.any? do |file|
          @gem.contains_path?(file)
        end
      end

      sig { params(constant: Module).returns(T::Array[String]) }
      def get_file_candidates(constant)
        wrapped_module = Pry::WrappedModule.new(constant)

        wrapped_module.candidates.map(&:file).to_a.compact
      rescue ArgumentError, NameError
        []
      end

      sig { params(name: String).void }
      def add_to_alias_namespace(name)
        @alias_namespace.add("#{name}::")
      end

      sig { params(name: String).returns(T::Boolean) }
      def alias_namespaced?(name)
        @alias_namespace.any? do |namespace|
          name.start_with?(namespace)
        end
      end

      sig { params(name: String).void }
      def mark_seen(name)
        @seen.add(name)
      end

      sig { params(name: String).returns(T::Boolean) }
      def seen?(name)
        @seen.include?(name)
      end

      sig { params(constant: Module).returns(T.nilable(String)) }
      def name_of(constant)
        name = name_of_proxy_target(constant, super(class_of(constant)))
        return name if name
        name = super(constant)
        return if name.nil?
        return unless are_equal?(constant, constantize(name, inherit: true))
        name = "Struct" if name =~ /^(::)?Struct::[^:]+$/
        name
      end

      sig { params(constant: T.all(Module, T::Generic)).returns(String) }
      def generic_name_of(constant)
        type_name = T.must(constant.name)
        return type_name if type_name =~ /\[.*\]$/

        type_variables = Tapioca::GenericTypeRegistry.lookup_type_variables(constant)
        return type_name unless type_variables

        type_variable_names = type_variables.map { "T.untyped" }.join(", ")

        "#{type_name}[#{type_variable_names}]"
      end

      sig { params(constant: Module, class_name: T.nilable(String)).returns(T.nilable(String)) }
      def name_of_proxy_target(constant, class_name)
        return unless class_name == "ActiveSupport::Deprecation::DeprecatedConstantProxy"
        # We are dealing with a ActiveSupport::Deprecation::DeprecatedConstantProxy
        # so try to get the name of the target class
        begin
          target = constant.__send__(:target)
        rescue NoMethodError
          return
        end

        name_of(target)
      end
    end
  end
end
