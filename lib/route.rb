# # Represents a route that our system can work with
Route = Struct.new(:start_node, :end_node, :start_time, :end_time) do
  def to_s
    "#{start_node} (#{start_time}) -> #{end_node} (#{end_time})"
  end
end
