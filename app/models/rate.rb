class Rate < ApplicationRecord

	validates :score, :inclusion => { :in => 1..5, :message => "%{value} is not a valid score" }

	belongs_to :post, :polymorphic => true

end