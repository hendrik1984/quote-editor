class Quote < ApplicationRecord
    belongs_to :company
    
    validates :title, presence: true

    scope :ordered, -> { order(id: :desc) }

    after_create_commit -> { broadcast_prepend_later_to "quotes_stream", partial: "quotes/quote", locals: { quote: self}, target: "quotes_list" }
    after_update_commit -> { broadcast_replace_later_to "quotes_stream", partial: "quotes/quote", locals: { quote: self}, target: self }
    after_destroy_commit -> { broadcast_remove_to "quotes_stream", partial: "quotes/quote", locals: { quote: self}, target: self }

    # All Three code above is equal to this 1 line number, but since i set/use the custom name "quotes_stream" using code below it not possible. maybe!
    # broadcast_to ->(quote) { "quotes" }, inserts_by: :prepend
end
