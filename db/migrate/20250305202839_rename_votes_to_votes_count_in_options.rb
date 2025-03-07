class RenameVotesToVotesCountInOptions < ActiveRecord::Migration[8.0]
  def change
    rename_column :options, :votes, :votes_count
  end
end
