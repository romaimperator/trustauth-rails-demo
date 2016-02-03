class StaticController < ApplicationController
  before_action do
    expires_in(1.day, public: true)
  end
end
