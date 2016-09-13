require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '1m' do
  memorySnapshot = Memory.new()
  memorySnapshot.read_xml('escp','dev')
  memorySnapshot.read_xml('es','dev')
  memorySnapshot.read_xml('escp','devint')
  memorySnapshot.read_xml('es','devint')
  memorySnapshot.read_xml('escp','int')
  memorySnapshot.read_xml('es','int')
  memorySnapshot.read_xml('escp','reg')
  memorySnapshot.read_xml('es','reg')
end

# scheduler.every '5h' do
#   puts "Scheduler"
#   memorySnapshot = Memory.new()
#   memorySnapshot.read_xml('escp','dev')
#   memorySnapshot.read_xml('es','dev')
#   memorySnapshot.read_xml('escp','devint')
#   memorySnapshot.read_xml('es','devint')
#   memorySnapshot.read_xml('escp','int')
#   memorySnapshot.read_xml('es','int')
#   memorySnapshot.read_xml('escp','reg')
#   memorySnapshot.read_xml('es','reg')
# end
