class TopicsController < ApplicationController
  include CommonModule
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.all.order("pubDate desc")
    @topics = @topics.page(params[:page]).per(20)
  end

  def show
  end

  def new
    if check_role(current_user)
      @topic = Topic.new
    end

  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @topic = Topic.new(topic_params)

      respond_to do |format|
        if @topic.save
          format.html { redirect_to @topic, notice: 'ニュースを登録しました。' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @topic.update(topic_params)
          format.html { redirect_to @topic, notice: 'ニュースを更新しました。' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if check_role(current_user)
      @topic.destroy
      respond_to do |format|
        format.html { redirect_to topics_url, notice: '対象のニュースを削除しました。' }
      end
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :link, :category, :pubDate)
    end
end
