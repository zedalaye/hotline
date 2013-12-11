# Sources
#   http://en.wikipedia.org/wiki/Erlang_unit
#   http://www.lokad.com/calculate-call-center-staffing-with-excel

module Erlang

  # Return Power(u, m) / Factorial(m) in a numeric-safe manner.
  def safe_power_fact(m, u)
    s = (1..m).inject(0.0) { |s, k| s + Math::log(u.to_f / k.to_f) }
    Math::exp(s)
  end

  # Return Factorial(n)
  def fact(n)
    (1..n).inject(1) { |r, i| r*i }
  end

  # Return Power(u, m) / Factorial(m)
  def power_fact(m, u)
    (u ** m).to_f / fact(m).to_f
  end

  # Returns the probability a call waits.
  #   m is the agent count
  #   u is the traffic intensity
  def erlang_c(m, u)
    d = power_fact(m, u)
    s = 1.0
    (1..(m - 1)).each do |k|
      s += power_fact(k, u)
    end
    d / (d + (1 - u / m) * s)
  end

  # Returns the average speed of answer (ASA)
  #   m is the agent counts.
  #   u is the traffic intensity
  #   tc is the average call time
  def asa(m, u, tc)
    erlang_c(m.to_f, u.to_f) * tc.to_f / (m.to_f - u.to_f)
  end

  # Returns the probability a call waits less than tt
  #   m is the agent count
  #   u is the traffic intensity
  #   tc is the average call time
  #   tt is the target wait time
  def erlang_c_srv(m, u, tc, tt)
    1 - erlang_c(m.to_f, u.to_f) * Math::exp(-(m.to_f - u.to_f) * (tt.to_f / tc.to_f))
  end

end