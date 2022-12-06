using HorizonSideRobots

module BaseRobot
    using HorizonSideRobots

    function get_interface(robot::Robot)
        
        move!(side::HorizonSide) = HorizonSideRobots.move!(robot, side)

        isborder(side::HorizonSide) = HorizonSideRobots.isborder(robot, side) 

        moves!(side::HorizonSide, n_steps::Int) = begin
            for i in 1:n_steps
                HorizonSideRobots.move!(robot, side)
            end
        end

        moves_until_border!(side::HorizonSide) = begin
            n_steps = 0
            while !HorizonSideRobots.isborder(robot, side)
                HorizonSideRobots.move!(robot, side)
                n_steps += 1
            end

            return n_steps
        end

        show() = HorizonSideRobots.show(robot)

        get_left_down_angle!() = begin
            steps = []
            while !HorizonSideRobots.isborder(robot, West) || !HorizonSideRobots.isborder(robot, Sud)
                
                steps_to_west= 0
                while !HorizonSideRobots.isborder(robot, West)
                    HorizonSideRobots.move!(robot, West)
                    steps_to_west += 1
                end

                steps_to_sud = 0
                while !HorizonSideRobots.isborder(robot, Sud)
                    HorizonSideRobots.move!(robot, Sud)
                    steps_to_sud += 1
                end

                push!(steps, (West, steps_to_west))
                push!(steps, (Sud, steps_to_sud))
            end

            return steps
        end

        function get_back!(path)
            inv_path = reverse(path)
            len = length(path)
            for i in 1:len
                inv_path[i] = (HorizonSide((Int(inv_path[i][1]) + 2) % 2), inv_path[i][2])  
            end

            for (side, n_steps) in inv_path
                for _ in 1:n_steps
                    HorizonSideRobots.move!(robot, side)
                end
            end

        end

        return (move! = move!, isborder = isborder, moves! = moves!, moves_until_border!, show = show,
                get_left_down_angle! = get_left_down_angle!, get_back! = get_back!)
    end
end


#Задача 11