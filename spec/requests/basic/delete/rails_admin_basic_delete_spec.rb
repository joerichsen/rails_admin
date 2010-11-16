require 'spec_helper'

describe "RailsAdmin Basic Delete" do
  include Warden::Test::Helpers

  before(:each) do
    RailsAdmin::AbstractModel.new("Division").destroy_all!
    RailsAdmin::AbstractModel.new("Draft").destroy_all!
    RailsAdmin::AbstractModel.new("Fan").destroy_all!
    RailsAdmin::AbstractModel.new("League").destroy_all!
    RailsAdmin::AbstractModel.new("Player").destroy_all!
    RailsAdmin::AbstractModel.new("Team").destroy_all!
    RailsAdmin::AbstractModel.new("User").destroy_all!

    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "test@test.com",
      :password => "test1234"
    )

    login_as user
  end

  after(:each) do
    Warden.test_reset!
  end
  
  describe "delete" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Delete model\"" do
      response.body.should contain("Delete player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      get rails_admin_delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")
      @team = RailsAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => rand(99999), :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)

      get rails_admin_delete_path(:model_name => "league", :id => @league.id)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end
end