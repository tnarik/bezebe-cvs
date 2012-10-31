FactoryGirl.define do

  factory :connection_details do
    username      "anonymous"
    password      "anonymous"
    host          "dev.w3.org"
    repository    "/sources/public"
  end

end