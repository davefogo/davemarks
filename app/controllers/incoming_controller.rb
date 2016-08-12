class IncomingController < ApplicationController
  require 'yaml'
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]

  def create
    # Find the user
     user = User.find_by(email: params[:sender])

     # Find the topic
     topic = Topic.find_by(title: params[:subject])

     # Assign the url to a variable after retreiving it from
     body_params = YAML.load(params['body-plain'])
     url = body_params[:url]
     description = body_params[:description]

     # If the user is nil, create and save a new user
     if user.nil?
       user = User.new(email: params[:sender], password: "password")
       user.save!
     end

     # If the topic is nil, create and save a new topic
      if topic.nil?
        topic = Topic.new(title: params[:subject], user: user)

        topic.save!
      end

      bookmark = topic.bookmarks.build(user: user, url: url, description: description)

      bookmark.save!

    # Assuming all went well.
    head 200
  end
end
