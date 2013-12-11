require_relative '../erlang'

include Erlang

number_of_calls       = 300
period_length         = 900 # p in seconds
average_call_duration = 180 # t in seconds
number_of_agents      = 65  # m
target_answer_time    = 15  # tt in seconds

def f(d, p = 2)
  "%8.#{p}f" % d
end

def fp(d)
  "#{f(d*100, 1)}%"
end

puts "Global"
puts "Number of Calls             = #{"%8d" % number_of_calls}"
puts "Period Length               = #{"%8d" % period_length}"
puts "Average Call Duration       = #{"%8d" % average_call_duration}"
puts "Number of Agents            = #{"%8d" % number_of_agents}"
puts "Target Answer Time          = #{"%8d" % target_answer_time}"
puts "---------------------------------------"

arrival_rate = number_of_calls.to_f / period_length.to_f # lambda
puts "Arrival Rate                = #{f(arrival_rate)}"

traffic_intensity = arrival_rate * average_call_duration # u
puts "Traffic Intensity           = #{f(traffic_intensity, 1)}"

agent_occupency = traffic_intensity / number_of_agents.to_f
puts "Agent Occupency             = #{fp(agent_occupency)}"

probability_to_wait = erlang_c(number_of_agents, traffic_intensity)
puts "Prob. to Wait               = #{fp(probability_to_wait)}"

average_speed_of_answer = asa(number_of_agents, traffic_intensity, average_call_duration)
puts "Average Speed of Answer     = #{f(average_speed_of_answer)}"

probability_to_wait_less = erlang_c_srv(number_of_agents, traffic_intensity, average_call_duration, target_answer_time)
puts "Prob. to Wait less than #{target_answer_time}s = #{fp(probability_to_wait_less)}"

# Tranches horaires

def simulate(time, calls, agents, p, t, tt)
  intensity = calls.to_f * t.to_f / p.to_f
  occupency = intensity / agents.to_f
  prob_to_wait = erlang_c(agents, intensity)
  avg_speed = asa(agents, intensity, t)
  prob_to_wait_less = erlang_c_srv(agents, intensity, t, tt)

  puts "#{time}\t#{"%4d" % calls}\t#{"%5d" % agents}\t#{f(intensity)}\t#{fp(occupency)}\t#{fp(prob_to_wait)}\t#{f(avg_speed)}\t#{fp(prob_to_wait_less)}"
end

puts

p  = 900
t  = 120
tt = 30

puts "Time slices"
puts "Period Length               = #{"%8d" % p}"
puts "Average Call Duration       = #{"%8d" % t}"
puts "Target Answer Time          = #{"%8d" % tt}"
puts "---------------------------------------"
puts

puts "Time\tCalls\tAgents\tIntensity\tOccupency\tProb to Wait\tAvg Speed\tWait < tt"
simulate('08:00',  70, 12, p, t, tt)
simulate('08:15',  80, 12, p, t, tt)
simulate('08:30', 100, 15, p, t, tt)
simulate('08:45', 110, 15, p, t, tt)
simulate('09:00', 130, 22, p, t, tt)
simulate('09:15', 150, 22, p, t, tt)
simulate('09:30', 150, 22, p, t, tt)
simulate('09:45', 150, 22, p, t, tt)
simulate('10:00', 140, 22, p, t, tt)
simulate('10:15', 140, 22, p, t, tt)
simulate('10:30', 140, 20, p, t, tt)
simulate('10:45', 130, 20, p, t, tt)
simulate('11:00', 130, 20, p, t, tt)
simulate('11:15', 120, 18, p, t, tt)
simulate('11:30', 120, 18, p, t, tt)
simulate('11:45', 120, 18, p, t, tt)