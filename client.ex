defmodule Client do
  def callServer(pid,nums) do
    send(pid, {nums, self()})
    listen()
  end

  def listen do
    receive do
	    {sorted, pid} -> sorted
    end
  end
end
