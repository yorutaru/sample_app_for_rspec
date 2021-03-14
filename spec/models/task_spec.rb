require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do 

    before do
      user = FactoryBot.build(:user)
    end
    
    it 'is valid with all attributes' do 
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'is invalid without title' do 
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'is valid with another title' do 
      FactoryBot.create(:task)
      task = FactoryBot.build(:task, title: "test_title_02")
      task.valid?
      expect(task).to be_valid
    end
  end
end
