Given /a user visits the signin page/ do
  visit signin_path
end

When /they submit invalid signin information/ do
  click_button "Sign in"
end

Then /they should see an error message/ do
  expect(page).to have_selector "alert-error"
end
