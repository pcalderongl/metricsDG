json.extract! metric, :id, :memory, :memoryFree, :processors, :heapCommited, :heapInit, :heapUsed, :created_at, :updated_at
json.url metric_url(metric, format: :json)