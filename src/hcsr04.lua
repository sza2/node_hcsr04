--
--    Copyright (C) 2014 Tamas Szabo <sza2trash@gmail.com>
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

hcsr04 = {};

function hcsr04.init(pin_trig, pin_echo, average)
	local self = {}
	self.time_start = 0
	self.time_end = 0
	self.trig = pin_trig or 4
	self.echo = pin_echo or 3
	gpio.mode(self.trig, gpio.OUTPUT)
	gpio.mode(self.echo, gpio.INT)
	self.average = average or 3

	function self.echo_cb(level)
		if level == 1 then
			self.time_start = tmr.now()
			gpio.trig(self.echo, "down")
		else
			self.time_end = tmr.now()
		end
	end

	function self.measure()
		gpio.trig(self.echo, "up", self.echo_cb)
		gpio.write(self.trig, gpio.HIGH)
		tmr.delay(100)
		gpio.write(self.trig, gpio.LOW)
		tmr.delay(100000)
		if (self.time_end - self.time_start) < 0 then
			return -1
		end
		return (self.time_end - self.time_start) / 5800
	end

	function self.measure_avg()
		if self.measure() < 0 then  -- drop the first sample
			return -1 -- if the first sample is invalid, return -1
		end
		avg = 0
		for cnt = 1, self.average do
			distance = self.measure()
			if distance < 0 then
				return -1 -- return -1 if any of the meas fails
			end
			avg = avg + distance
			tmr.delay(30000)
		end
		return avg / self.average
	end

	return self
end
