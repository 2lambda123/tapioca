# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rubocop-factory_bot` gem.
# Please instead update this file by running `bin/tapioca gem rubocop-factory_bot`.

# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#3
module RuboCop; end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#4
module RuboCop::Cop; end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#5
module RuboCop::Cop::FactoryBot; end

# Always declare attribute values as blocks.
#
# @example
#   # bad
#   kind [:active, :rejected].sample
#
#   # good
#   kind { [:active, :rejected].sample }
#
#   # bad
#   closed_at 1.day.from_now
#
#   # good
#   closed_at { 1.day.from_now }
#
#   # bad
#   count 1
#
#   # good
#   count { 1 }
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#27
class RuboCop::Cop::FactoryBot::AttributeDefinedStatically < ::RuboCop::Cop::Base
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#85
  def association?(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#38
  def factory_attributes(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#42
  def on_block(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#33
  def value_matcher(param0 = T.unsafe(nil)); end

  private

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#119
  def attribute_defining_method?(method_name); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#58
  def autocorrect(corrector, node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#87
  def autocorrect_replacing_parens(corrector, node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#94
  def autocorrect_without_parens(corrector, node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#103
  def braces(node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#66
  def offensive_receiver?(receiver, node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#80
  def proc?(attribute); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#72
  def receiver_matches_first_block_argument?(receiver, node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#115
  def reserved_method?(method_name); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#111
  def value_hash_without_braces?(node); end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/attribute_defined_statically.rb#30
RuboCop::Cop::FactoryBot::AttributeDefinedStatically::MSG = T.let(T.unsafe(nil), String)

# Use a consistent style for parentheses in factory bot calls.
#
# @example
#
#   # bad
#   create :user
#   build(:user)
#   create(:login)
#   create :login
# @example `EnforcedStyle: require_parentheses` (default)
#
#   # good
#   create(:user)
#   create(:user)
#   create(:login)
#   build(:login)
# @example `EnforcedStyle: omit_parentheses`
#
#   # good
#   create :user
#   build :user
#   create :login
#   create :login
#
#   # also good
#   # when method name and first argument are not on same line
#   create(
#   :user
#   )
#   build(
#   :user,
#   name: 'foo'
#   )
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#42
class RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle < ::RuboCop::Cop::Base
  include ::RuboCop::Cop::ConfigurableEnforcedStyle
  include ::RuboCop::FactoryBot::Language
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#60
  def factory_call(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#67
  def on_send(node); end

  private

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#104
  def ambiguous_without_parentheses?(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#83
  def process_with_parentheses(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#93
  def process_without_parentheses(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#108
  def remove_parentheses(corrector, node); end

  class << self
    # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#48
    def autocorrect_incompatible_with; end
  end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#102
RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle::AMBIGUOUS_TYPES = T.let(T.unsafe(nil), Array)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#55
RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle::FACTORY_CALLS = T.let(T.unsafe(nil), Set)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#53
RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle::MSG_OMIT_PARENS = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#52
RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle::MSG_REQUIRE_PARENS = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/consistent_parentheses_style.rb#57
RuboCop::Cop::FactoryBot::ConsistentParenthesesStyle::RESTRICT_ON_SEND = T.let(T.unsafe(nil), Set)

# Checks for create_list usage.
#
# This cop can be configured using the `EnforcedStyle` option
#
# @example `EnforcedStyle: create_list` (default)
#   # bad
#   3.times { create :user }
#
#   # good
#   create_list :user, 3
#
#   # bad
#   3.times { create :user, age: 18 }
#
#   # good - index is used to alter the created models attributes
#   3.times { |n| create :user, age: n }
#
#   # good - contains a method call, may return different values
#   3.times { create :user, age: rand }
# @example `EnforcedStyle: n_times`
#   # bad
#   create_list :user, 3
#
#   # good
#   3.times { create :user }
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#33
class RuboCop::Cop::FactoryBot::CreateList < ::RuboCop::Cop::Base
  include ::RuboCop::Cop::ConfigurableEnforcedStyle
  include ::RuboCop::FactoryBot::Language
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#63
  def arguments_include_method_call?(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#43
  def array_new_or_n_times_block?(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#54
  def block_with_arg_and_used?(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#68
  def factory_call(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#73
  def factory_list_call(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#77
  def on_block(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#91
  def on_send(node); end

  private

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#104
  def contains_only_factory?(node); end
end

# :nodoc
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#113
module RuboCop::Cop::FactoryBot::CreateList::Corrector
  private

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#116
  def build_options_string(options); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#120
  def format_method_call(node, method, arguments); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#128
  def format_receiver(receiver); end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#173
class RuboCop::Cop::FactoryBot::CreateList::CreateListCorrector
  include ::RuboCop::Cop::FactoryBot::CreateList::Corrector

  # @return [CreateListCorrector] a new instance of CreateListCorrector
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#176
  def initialize(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#180
  def call(corrector); end

  private

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#203
  def build_arguments(node, count); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#212
  def call_replacement(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#194
  def call_with_block_replacement(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#225
  def count_from(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#235
  def format_block(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#243
  def format_multiline_block(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#251
  def format_singleline_block(node); end

  # Returns the value of attribute node.
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#192
  def node; end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#38
RuboCop::Cop::FactoryBot::CreateList::MSG_CREATE_LIST = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#39
RuboCop::Cop::FactoryBot::CreateList::MSG_N_TIMES = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#40
RuboCop::Cop::FactoryBot::CreateList::RESTRICT_ON_SEND = T.let(T.unsafe(nil), Array)

# :nodoc
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#136
class RuboCop::Cop::FactoryBot::CreateList::TimesCorrector
  include ::RuboCop::Cop::FactoryBot::CreateList::Corrector

  # @return [TimesCorrector] a new instance of TimesCorrector
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#139
  def initialize(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#143
  def call(corrector); end

  private

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#165
  def factory_call_block_source; end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#152
  def generate_n_times_block(node); end

  # Returns the value of attribute node.
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/create_list.rb#150
  def node; end
end

# Use string value when setting the class attribute explicitly.
#
# This cop would promote faster tests by lazy-loading of
# application files. Also, this could help you suppress potential bugs
# in combination with external libraries by avoiding a preload of
# application files from the factory files.
#
# @example
#   # bad
#   factory :foo, class: Foo do
#   end
#
#   # good
#   factory :foo, class: 'Foo' do
#   end
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#22
class RuboCop::Cop::FactoryBot::FactoryClassName < ::RuboCop::Cop::Base
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#31
  def class_name(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#35
  def on_send(node); end

  private

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#48
  def allowed?(const_name); end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#27
RuboCop::Cop::FactoryBot::FactoryClassName::ALLOWED_CONSTANTS = T.let(T.unsafe(nil), Array)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#25
RuboCop::Cop::FactoryBot::FactoryClassName::MSG = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_class_name.rb#28
RuboCop::Cop::FactoryBot::FactoryClassName::RESTRICT_ON_SEND = T.let(T.unsafe(nil), Array)

# Checks for name style for argument of FactoryBot::Syntax::Methods.
#
# @example EnforcedStyle: symbol (default)
#   # bad
#   create('user')
#   build "user", username: "NAME"
#
#   # good
#   create(:user)
#   build :user, username: "NAME"
# @example EnforcedStyle: string
#   # bad
#   create(:user)
#   build :user, username: "NAME"
#
#   # good
#   create('user')
#   build "user", username: "NAME"
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#26
class RuboCop::Cop::FactoryBot::FactoryNameStyle < ::RuboCop::Cop::Base
  include ::RuboCop::Cop::ConfigurableEnforcedStyle
  include ::RuboCop::FactoryBot::Language
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#36
  def factory_call(param0 = T.unsafe(nil)); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#43
  def on_send(node); end

  private

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#59
  def offense_for_string_style?(name); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#55
  def offense_for_symbol_style?(name); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#63
  def register_offense(name, prefer); end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#32
RuboCop::Cop::FactoryBot::FactoryNameStyle::FACTORY_CALLS = T.let(T.unsafe(nil), Set)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#31
RuboCop::Cop::FactoryBot::FactoryNameStyle::MSG = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/factory_name_style.rb#33
RuboCop::Cop::FactoryBot::FactoryNameStyle::RESTRICT_ON_SEND = T.let(T.unsafe(nil), Set)

# Use shorthands from `FactoryBot::Syntax::Methods` in your specs.
#
# @example
#   # bad
#   FactoryBot.create(:bar)
#   FactoryBot.build(:bar)
#   FactoryBot.attributes_for(:bar)
#
#   # good
#   create(:bar)
#   build(:bar)
#   attributes_for(:bar)
#
# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#48
class RuboCop::Cop::FactoryBot::SyntaxMethods < ::RuboCop::Cop::Base
  include ::RuboCop::Cop::RangeHelp
  include ::RuboCop::FactoryBot::Language
  extend ::RuboCop::Cop::AutoCorrector

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#73
  def on_send(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#58
  def spec_group?(param0 = T.unsafe(nil)); end

  private

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#87
  def crime_scene(node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#109
  def example_group_root?(node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#113
  def example_group_root_with_siblings?(node); end

  # @return [Boolean]
  #
  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#101
  def inside_example_group?(node); end

  # source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#94
  def offense(node); end
end

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#53
RuboCop::Cop::FactoryBot::SyntaxMethods::MSG = T.let(T.unsafe(nil), String)

# source://rubocop-factory_bot//lib/rubocop/cop/factory_bot/syntax_methods.rb#55
RuboCop::Cop::FactoryBot::SyntaxMethods::RESTRICT_ON_SEND = T.let(T.unsafe(nil), Set)

# RuboCop FactoryBot project namespace
#
# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#5
module RuboCop::FactoryBot
  class << self
    # source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#54
    def attribute_defining_methods; end

    # source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#58
    def reserved_methods; end
  end
end

# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#6
RuboCop::FactoryBot::ATTRIBUTE_DEFINING_METHODS = T.let(T.unsafe(nil), Array)

# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#29
RuboCop::FactoryBot::DEFINITION_PROXY_METHODS = T.let(T.unsafe(nil), Array)

# Contains node matchers for common FactoryBot DSL.
#
# source://rubocop-factory_bot//lib/rubocop/factory_bot/language.rb#6
module RuboCop::FactoryBot::Language
  extend ::RuboCop::AST::NodePattern::Macros

  # source://rubocop-factory_bot//lib/rubocop/factory_bot/language.rb#30
  def factory_bot?(param0 = T.unsafe(nil)); end
end

# source://rubocop-factory_bot//lib/rubocop/factory_bot/language.rb#9
RuboCop::FactoryBot::Language::METHODS = T.let(T.unsafe(nil), Set)

# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#42
RuboCop::FactoryBot::RESERVED_METHODS = T.let(T.unsafe(nil), Array)

# source://rubocop-factory_bot//lib/rubocop/factory_bot/factory_bot.rb#14
RuboCop::FactoryBot::UNPROXIED_METHODS = T.let(T.unsafe(nil), Array)
