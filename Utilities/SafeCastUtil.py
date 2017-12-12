class SafeCastUtil(object):

    @staticmethod
    def safeCast(val, to_type, default=None):
        try:
            return to_type(val)
        except (ValueError, TypeError):
            return default

    @staticmethod
    def getMatrixShapeNullSafe(matrix):
        matrix_shape = matrix.shape
        if len(matrix_shape) == 1:
            return matrix_shape[0], 1
        elif len(matrix_shape) > 1:
            return matrix_shape
        else:
            return 0, 0
