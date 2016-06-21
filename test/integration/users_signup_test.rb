require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
      get signup_path
      assert_no_difference 'User.count' do
          post users_path, user: { email: "hello@hello",
                                  password: "hello",
                                  password_confirmation: "nothello" }
      end
      assert_template 'users/new'

  end
end
