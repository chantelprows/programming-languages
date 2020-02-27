defmodule Elixir_Intro do

	def fib(n) do
		case n do
			1 -> 1
			2 -> 1
			_ -> fib(n-1) + fib(n-2)
		end
	end

	def area(:rectangle, shape_info) do
		elem(shape_info, 0) * elem(shape_info, 1)
	end

	def area(:square, shape_info) do
		shape_info * shape_info
	end

	def area(:circle, shape_info) do
		(shape_info * shape_info) * :math.pi
	end

	def area(:triangle, shape_info) do
		(elem(shape_info, 0) * elem(shape_info, 1)) / 2
	end

	def sqrList(nums) do
		Enum.map(nums, fn x -> x * x end)
	end

	def calcTotals(inventory) do
		Enum.map(inventory, fn {item, quantity, price} -> {item, quantity * price} end)
	end

	def map(function, vals) do
		function.(hd(vals))
	end

	def quickSortServer() do
		receive do
			{message, pid} ->
				send(pid, {quickSort(message), self()})
		end
		quickSortServer()
	end

	def quickSort([]) do
		[]
	end

	def quickSort(list) do
		position = :rand.uniform(1) - 1
		pivot = Enum.at(list, position)
		restOfList = List.delete_at(list, position)
		{left, right} = Enum.split_with(restOfList, fn x -> x < pivot end)
		quickSort(left) ++ [pivot] ++ quickSort(right)
	end

end
