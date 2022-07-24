class WordController < ApplicationController
  before_action :is_valid_word?, except: [:getWord]
  before_action :is_valid_api?
  before_action :check_daily_limit

  def getWord
    render json: {"word": Word.all[Random.new.rand(Word.all.length)].word_name}, status: :ok
  end

  def getDefinitions
    render json: {"Word": params[:word], "Definitions":Definition.fetch_definition(Word.find_by(word_name:params[:word]))}
  end

  def getExamples
    render json: {"Word": params[:word], "Examples":Example.fetch_example(Word.find_by(word_name:params[:word]))}
  end

  def getSynonyms
    render json: {"Word": params[:word], "Synonyms":Synonym.fetch_synonym(Word.find_by(word_name:params[:word]))}
  end

  def getAntonyms
    render json: {"Word": params[:word], "Antonyms":Antonym.fetch_antonym(Word.find_by(word_name:params[:word]))}
  end

  private
  def is_valid_word?
    if (Word.is_valid_word?(params[:word]) == nil)
      return render json: {"message":"Invalid Word"}
    end
  end

  def is_valid_api?
    if (ApiKey.validate_api_key(params[:api_key]) == nil)
      return render json: {"message":"Invalid API Key"}
    end
  end

  def check_daily_limit
    if (ApiKey.check_daily_limit(params[:api_key]) == "Daily Quota Exceeded")
      render json:{"message":"Daily Quota Exceeded"}
    end
  end
end
