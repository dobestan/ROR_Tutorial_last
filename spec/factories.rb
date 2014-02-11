FactoryGirl.define do
  factory :user do
    name              "example man"
    email             "dobestan@test.com"
    password          "foobar"
    password_confirmation          "foobar"
  end
end
