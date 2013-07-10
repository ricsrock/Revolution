class DestroyDonationsWithBlankAmount < ActiveRecord::Migration
  def change
    donations = Donation.where('amount IS NULL OR amount LIKE ?', ' ')
    donations.destroy_all
  end
end
