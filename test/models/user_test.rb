# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  fullname        :string
#  is_admin        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user name (pre-validation and) validation is OK" do
    u = User.new(name: "aNameNotOk ", email: "ok@test.org", password: "test", password_confirmation: "test")
    #byebug
    assert u.valid?
    assert u.name == "anamenotok"
  end

  test "user email (pre-validation and) validation is OK" do
    u = User.new(name: "nameok", email: " NotOkk@tEst.org ", password: "test", password_confirmation: "test")

    assert u.valid?
    assert u.email == "notokk@test.org"
  end
end
