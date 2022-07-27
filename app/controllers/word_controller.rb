class WordController < ApplicationController
  before_action :fetch_word, except: [ :getWord, :getAllWords ]
  before_action :fetch_api_key, except: [ :getAllWords ]
  before_action :check_daily_limit, except: [ :getAllWords ]

  def getAllWords
    render json: { Words: Word.pluck(:word_name) }
  end

  def getWord
    render json: { Word: Word.offset(rand(Word.count)).first.word_name }, status: :ok
  end

  def getDefinitions
    render json: { Word: @word.word_name, Definitions: @word.definitions.pluck(:text) }, status: :ok
  end

  def getExamples
    render json: { Word: @word.word_name, Examples: @word.examples.pluck(:text) }, status: :ok
  end

  def getSynonyms
    render json: { Word: @word.word_name, Synonyms: @word.synonyms.pluck(:text) }, status: :ok
  end

  def getAntonyms
    render json: { Word: @word.word_name, Antonyms: @word.antonyms.pluck(:text) }, status: :ok
  end

  private
  def fetch_word
    @word = Word.find_by( word_name: params[:word] )
    return render json: { message: "Invalid Word" } if @word == nil
  end

  def fetch_api_key
    @api_key = ApiKey.find_by( api_key: params[:api_key] )
    return render json: { message: "Invalid API Key" } if @api_key == nil
  end

  def check_daily_limit
    if @api_key.daily_limit_reached?
      return render json: { error: "Daily Limit of #{@api_key.usage_limit} reached" }
    end
    if Time.now - 1.day >= @api_key.created_at
      @api_key.reset_frequency
    else
      @api_key.increment_usage!
    end
  end
end
