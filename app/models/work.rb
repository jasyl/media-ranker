class Work < ApplicationRecord
  validates :category, presence: true
  validates :title, presence: true, uniqueness: true
  has_many :votes
  has_many :users, through: :votes



  def self.spotlight
    work_no_nil = where.not(votes_count: nil).order("votes_count DESC, created_at DESC")
    work_yes_nil = where(votes_count: nil).order(created_at: :desc)
    return work_no_nil.empty? ? work_yes_nil.first : work_no_nil.first
  end

  def self.top_ten(category)
    return order_by_votes(category).first(10)
  end

  def self.order_by_votes(category)
    works = where(category: category)
    works_nil_votes = works.where(votes_count: nil).order(title: :asc)
    works_no_nil_votes = works.where.not(votes_count: nil).order("votes_count DESC, title")
    return works_no_nil_votes + works_nil_votes
  end

  def single_or_plural_votes
    if votes_count == 1
      return "1 Vote"
    elsif votes_count == nil
      return "0 Votes"
    else
      return "#{votes_count} Votes"
    end
  end



  private

  # def destroy_votes
  #   votes.delete_all
  # end
end
