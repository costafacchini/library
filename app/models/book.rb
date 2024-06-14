# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true

  has_many :borrows, dependent: :destroy

  before_save :fill_search_with_values
  scope :by_expression, ->(expression) { search_by(expression) if expression.present? }

  def available?
    borrows.where(borrows: { returned_at: nil }).count.zero?
  end

  def self.search_by(expression)
    expression = prepare_expression(expression)
    expression_words = expression.split.map { |word| "%,#{word}%" }
    search = initialize_search

    filters = Array.new(expression_words.count)

    add_filter(filters)

    search.where filters.join(' AND '), *expression_words
  end

  private

  def fill_search_with_values
    search_value = ''
    %i[title author genre].each do |attribute|
      attribute_value = send(attribute)
      search_value += prepare_value_to_fill_search_attribute(attribute_value) if attribute_value
    end
    send(:search=, search_value) if search_value.present?
  end

  def prepare_value_to_fill_search_attribute(value)
    value = I18n.transliterate(value.to_s).downcase.tr(',', ' ')

    processed_value = ''
    value.split.each do |item|
      processed_value += remove_special_characters(item) if item != '-'
    end
    processed_value
  end

  def remove_special_characters(value)
    value = remove_special_characters_between_numbers(value)

    if contains_dash_or_slash?(value)
      duplicate_value_in_two_forms_of_writing(value)
    else
      ",#{value}"
    end
  end

  def remove_special_characters_between_numbers(value)
    value = remove_dot_between_numbers(value)
    value = remove_dash_between_numbers(value)
    remove_slash_between_numbers(value)
  end

  def remove_dot_between_numbers(value)
    value.gsub(/(?<=\d)\.(?=\d)/, '')
  end

  def remove_dash_between_numbers(value)
    value.gsub(/(?<=\d)-(?=\d)/, '')
  end

  def remove_slash_between_numbers(value)
    value.gsub(%r{(?<=\d)/(?=\d)}, '')
  end

  def contains_dash_or_slash?(value)
    (value.include? '-') || (value.include? '/')
  end

  def duplicate_value_in_two_forms_of_writing(value)
    ",#{value_without_dash_and_slash(value)},#{value_without_dash_and_slash_separated_by_commas(value)}"
  end

  def value_without_dash_and_slash(value)
    value.delete('-').delete('/')
  end

  def value_without_dash_and_slash_separated_by_commas(value)
    value.tr('-', ' ').tr('/', ' ').split.join(',')
  end

  def self.prepare_expression(expression)
    expression = I18n.transliterate(expression.to_s).downcase
    expression = expression.gsub(/(?<=\d)\.(?=\d)/, '')
    expression = expression.gsub '%', '\%'
    expression = expression.delete('-')
    expression.delete('/')
  end
  private_class_method :prepare_expression

  def self.initialize_search
    all
  end
  private_class_method :initialize_search

  def self.add_filter(condition)
    condition.map! { "COALESCE(#{arel_table.name}.search, '') LIKE ?" }
  end
  private_class_method :add_filter
end
