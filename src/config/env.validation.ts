import Joi from 'joi';

export function validate(config: Record<string, unknown>) {
    const envValidationSchema = Joi.object({
        NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
        PORT: Joi.number().port().min(1).default(3000),
    });

    const { error, value } = envValidationSchema.validate(config, {
        allowUnknown: true,
        abortEarly: false,
    });

    if (error) {
        throw new Error(`Environment validation failed: ${error.message}`);
    }

    return value;
}
