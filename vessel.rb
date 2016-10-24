#!/bin/env ruby
# encoding: utf-8

$instance_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

class Disms

  include Vessel

  def twitter_account

    return "dictionarism"

  end

  def make_ism q = nil

    timeDiff  = Time.new.to_i - Date.new(2015,8,21).to_time.to_i
    daysGone  = (timeDiff/86400)
    chapter   = (daysGone * 24) + Time.now.hour

    word_type = ""

    dict = {}

    Memory_Array.new("dictionary").to_a.each do |line|
      word_type = line['C']
      if !dict[word_type] then dict[word_type] = [] end
      dict[word_type].push(line['WORD'])
    end
    
    word = q.to_s != "" ? q : dict["N"][chapter % dict["N"].length]

    # -te
    if word[-2,2] == "te"
      word = word[0...-1]+"ism"
    # -ve
    elsif word[-2,2] == "ve"
      word = word[0...-1]+"ism"
    # -ly
    elsif word[-2,2] == "ly"
      word = word+"ism"   
    # -ed
    elsif word[-2,2] == "ed"
      word = word[0...-2]+"ism"
    # -ist
    elsif word[-3,3] == "ist"
      word = word[0...-3]+"ism"
    # -y
    elsif word[-1,1] == "y"
      word = word[0...-1]+"ism"
    else
      word += "ism"
    end

    return word.capitalize

  end

  # Actions

  class Actions

    include ActionCollection
    include ActionTweet

    def tweet_auto

      return tweet(@actor.make_ism)

    end

    def tweet_reply_auto

      last_reply  = last_replies.first
      username    = last_reply.user.screen_name
      target_word = last_reply.text.downcase.split(' ').last.gsub(/[^0-9a-z]/i, '')

      if username.like(@actor.twitter_account) then return "Repying to self." end
        
      # Check memory

      ra = Ra.new("memory",$instance_path)
      if ra.to_s == "#{username}:#{target_word}" then return "Already replied." end

      # Make Word

      word = @actor.make_ism(target_word)
      tweet_reply(last_reply,"#{word}\nFor @#{username}.",true)

      # Update memory
      ra.replace("#{username}:#{target_word}")
      return "Created word: #{word}"

    end

  end

  def actions ; return Actions.new(self,self) end

end