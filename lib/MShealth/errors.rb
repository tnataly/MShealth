module MShealth
  module Errors
    class MShealthError < StandardError; end

    class UnauthorizedError < MShealthError; end

    class BadRequestError < MShealthError; end

    class ForbiddenError < MShealthError; end

    class NotFoundError < MShealthError; end

    class TooManyRequestsError < MShealthError; end

    class ServerError < MShealthError; end

  end
end
