require 'spec_helper'

describe SimpleForum::Forum do

  it "table should exists" do
    SimpleForum::Forum.table_exists?.should be_true
  end

end

