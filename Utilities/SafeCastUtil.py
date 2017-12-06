class SafeCastUtil(object):

    @staticmethod
    def safeCast(val, to_type, default=None):
        try:
            return to_type(val)
        except (ValueError, TypeError):
            return default