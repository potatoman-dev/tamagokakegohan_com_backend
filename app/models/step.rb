class Step < ApplicationRecord
  belongs_to :recipe

  # before_save :set_step_number, if: :new_record?
  # after_save :update_step_numbers, if: :saved_change_to_step_number?
  validates :step_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  before_validation :set_step_number, on: :create

  validates :instruction, presence: true

  mount_uploader :image, StepImageUploader

  private

  def set_step_number
    if recipe
      self.step_number = recipe.steps.count + 1
    end
  end

  # def set_step_number
  #   if self.step_number.nil?
  #     max_step_number = self.recipe.steps.maximum(:step_number) || 0
  #     self.step_number = max_step_number + 1
  #   end
  # end

  # def update_step_numbers
  #   if self.recipe.steps.where.not(id: self.id).exists?(step_number: self.step_number)
  #     self.recipe.steps
  #       .where('step_number >= ?', self.step_number)
  #       .where.not(id: self.id)
  #       .update_all('step_number = step_number + 1')
  #   end
  # end
end
