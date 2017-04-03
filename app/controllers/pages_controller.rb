class PagesController < ApplicationController

  def game
    @grid = (0...10).to_a.map { |_i| (rand(26) + 97).chr }
    if params[:log_out] == "true"
      session[:current_user_id] = nil
      params[:log_out] = "false"
    end
    if params[:log_in] == "true"
      session[:current_user_id] = params[:user]
      params[:log_in] = "false"
    end
  end

  def score

    @time = Time.now.to_i - params[:start_time].to_i

    @answer = params[:answer]

    @grid = params[:grid].split("")

    @results = in_grid?(@answer, @grid)

    @score = @results ? @answer.length - @time / 3 : 0

    @translation = translation(@answer)

    puts @translation

  end

  def in_grid?(attempt, grid1)
    grid = grid1.dup
    attempt.split("").each do |i|
      if grid.include? i
        grid.slice!(grid.index(i))
      else
        return(false)
      end
    end
    return(true)
  end

  def translation(word)
    url = "https://api-platform.systran.net/translation/text/translate?sou"\
    "rce=en&target=fr&key=eaf52d2e-e2f3-435d-b3e9-3b0e899b9515&input=#{word}"
    user_serialized = open(url).read
    translation = JSON.parse(user_serialized)["outputs"][0]["output"]
    if translation == word
      return("NO TRANSLATION FOUND")
    else
      return(translation)
    end
  end

end
