require 'httparty'
require 'dotenv'
require 'pry'
require 'table_print'

require_relative 'workspace'
require_relative 'channel'
require_relative 'member'
Dotenv.load

class Workspace
  attr_reader :users, :channels

  CHANNEL_URL = 'https://slack.com/api/channels.list'
  MEMBER_URL = "https://slack.com/api/users.list"
  MESSAGE_URL = 'https://slack.com/api/chat.postMessage'

  def initialize
    @users = list_members
    @channels = list_channels
  end

# channel's name, topic, member count, and Slack ID.
  def list_channels
    query_parameters = {
      token: ENV['SLACK_TOKEN']
    }

    response = HTTParty.post(CHANNEL_URL, query: query_parameters)["channels"]
    
    response.map {|channel| 
      Channel.new(
        name: channel["name"],
        topic: channel["topic"]["value"],
        member_count: channel["members"].length,
        id: channel["id"]
      )
    }
  end

# username, real name, and Slack ID
  def list_members
    query_parameters = {
      token: ENV['SLACK_TOKEN']
    }

    response = HTTParty.post(MEMBER_URL, query: query_parameters)["members"]
    
    response.map {|member| 
      Member.new(
        name: member["name"], 
        real_name: member["profile"]["real_name"], 
        id: member["id"]
      )
    }
  end
end