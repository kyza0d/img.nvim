local utils = require("imagine.utils")

-- Provides functions for working with images
-- @module viewer
local viewer = {}

-- When calling request, a set of instructions should be provided for ueberzug
-- @param job_spec a table of arguments given to ueberzug
-- @param job_id a unique id for referencing jobs
function viewer:request(job_spec, job_id)
	-- Check if the current buffer has a buffer variable, if so then assign job_id to the buffer variable
	if vim.b.job_id ~= nil then
		goto continue
	end

	-- If a id isn't provided then use unique id
	job_id = job_id or os.time()

	-- Assign buffer-specific variable
	vim.b.job_id = job_id

	::continue::

	job_id = vim.b.job_id

	return {
		job_spec = job_spec, -- Used later for storing jobs
		job_id = job_id, -- Used for identifying jobs
	}
end

local jobs = {}

-- Starts a job
-- @param job_spec job
-- @param job_id
function jobs:register(job_spec, job_id)
	local job = vim.fn.jobstart(job_spec)

	jobs[job_id] = {}
	jobs[job_id].job_spec = job
end

-- Start a background job
-- @param job starts a job
function viewer:job_start(job)
	jobs:register(utils.concat(job.job_spec, " "), job.job_id)
end

-- Stops a running job
-- @param job_id unique id, and vim.b.job_id
function jobs:kill(job_id)
	-- TODO: simplify nesting
	local job = job_id.job_id
	vim.fn.jobstop(jobs[job].job_spec)
end

-- Fetches returns job from jobs table
-- @param job_id unique indetifier, and vim.b.job_id
function jobs:fetch_job_id(buffer)
	buffer = vim.b.job_id
	local job_id = buffer
	return {
		job_id = job_id,
	}
end

return { viewer = viewer, jobs = jobs }