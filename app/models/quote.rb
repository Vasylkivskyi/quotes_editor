class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # Long detailed version
  # after_create_commit -> {
  #                       broadcast_prepend_to "quotes",
  #                                            partial: "quotes/quote",
  #                                            locals: {
  #                                              quote: self
  #                                            },
  #                                            target: "quotes" # Can be removed because by default, the target option will be equal to model_name.plural, which is equal to "quotes"
  #                     }

  # shorter version
  after_create_commit -> { broadcast_prepend_to "quotes" }
  # There are two other conventions we can use to shorten our code. Under the hood, Turbo has a default value for both the partial and the locals option.

  # The partial default value is equal to calling to_partial_path on an instance of the model, which by default in Rails for our Quote model is equal to "quotes/quote".
  # The locals default value is equal to { model_name.element.to_sym => self } which, in in the context of our Quote model, is equal to { quote: self }.

  # broadcast ufter quote was updated (short version)
  after_update_commit -> { broadcast_replace_to "quotes" }

  # broadcast ufter quote was deleted (short version)
  after_destroy_commit -> { broadcast_remove_to "quotes" }
end
