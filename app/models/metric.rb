class Metric
  include Mongoid::Document
  field :memory, type: Integer
  field :memoryFree, type: Integer
  field :processors, type: Integer
  field :heapCommited, type: Integer
  field :heapInit, type: Integer
  field :heapUsed, type: Integer
end
