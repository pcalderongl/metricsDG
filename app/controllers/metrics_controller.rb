class MetricsController < ApplicationController
  before_action :set_metric, only: [:show, :edit, :update, :destroy]

  # GET /metrics
  # GET /metrics.json
  def index
    @metrics = Metric.all
    @chartLists = getMemoryData()
  end

  def getMemoryData()
    chartLists = Hash.new()
    memoryFreeChart = Hash.new()
    memoryChart = Hash.new()
    heapCommitedChart = Hash.new()
    heapInitChart = Hash.new()
    heapUsedChart = Hash.new()
    Metric.all.each do |m|
      memoryFreeChart["#{m.id.generation_time}"] = m.memoryFree
      memoryChart["#{m.id.generation_time}"] = m.memory
      heapCommitedChart["#{m.id.generation_time}"] = m.heapCommited
      heapInitChart["#{m.id.generation_time}"] = m.heapInit
      heapUsedChart["#{m.id.generation_time}"] = m.heapUsed
    end
    chartLists["memoryFreeChart"] = memoryFreeChart
    chartLists["memoryChart"] = memoryChart
    chartLists["heapCommited"] = heapCommitedChart
    chartLists["heapInit"] = heapInitChart
    chartLists["heapUsed"] = heapUsedChart
    return chartLists
  end

  # GET /metrics/1
  # GET /metrics/1.json
  def show
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # GET /metrics/1/edit
  def edit
  end

  # POST /metrics
  # POST /metrics.json
  def create
    @metric = Metric.new(metric_params)

    respond_to do |format|
      if @metric.save
        format.html { redirect_to @metric, notice: 'Metric was successfully created.' }
        format.json { render :show, status: :created, location: @metric }
      else
        format.html { render :new }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metrics/1
  # PATCH/PUT /metrics/1.json
  def update
    respond_to do |format|
      if @metric.update_attributes(metric_params)
        format.html { redirect_to @metric, notice: 'Metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /metrics/1
  # DELETE /metrics/1.json
  def destroy
    @metric.destroy
    respond_to do |format|
      format.html { redirect_to metrics_url, notice: 'Metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric
      @metric = Metric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_params
      params.require(:metric).permit(:memory, :memoryFree, :processors, :heapCommited, :heapInit, :heapUsed)
    end
end
