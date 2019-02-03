#!/bin/env ruby
# encoding: utf-8

$nataniev.require("action","tweet")

class VesselDictionarism

    include Vessel

    def initialize id = 0

        super

        @name = "Dictionarism"
        @docs = "A twitter bot that makes -isms out of words. A fork of an old [Nataniev automaton](https://wiki.xxiivv.com/#dictionarism)"
        @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

        install(:default, :generate)
        install(:generic, :document)
        install(:generic, :tweet)

    end

end

class ActionGenerate

  include Action

  def act q = nil

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

end

class ActionTweet

  def account

    return "dictionarism"

  end

  def payload

    return ActionGenerate.new(@host).act

  end

end
