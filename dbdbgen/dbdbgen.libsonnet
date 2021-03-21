{
    /// Decodes the given hex string into an array of u32.
    local hexDecodeU32(str) =
        [std.parseHex(str[(i<<3)-8:i<<3]) for i in std.range(1, std.length(str)>>3)],

    /// Encodes the array of u32 into a hex string.
    local hexEncodeU32(u32s) =
        std.join('', [std.format('%08x', b) for b in u32s]),

    /// Generates a new seed by xor with a salt hex string.
    xorSeed(seed, salt)::
        local seedBytes = hexDecodeU32(seed);
        local saltBytes = hexDecodeU32(salt);
        local xor = std.mapWithIndex(function(i, a) a ^ saltBytes[i], seedBytes);
        hexEncodeU32(xor),


    /// Used in argument values, indicating the argument should be chosen from a
    /// list of possible choices.
    choices(choices, multiple=false)::
        {choices: {choices: choices, multiple: multiple}},

    /// The standard CLI arguments.
    stdArgs:: {
        qualified: {
            help: 'Keep the qualified name when writing the SQL statements.',
            type: 'bool',
        },
        schema_name: {
            long: 'schema-name',
            help: 'Override the schema name.',
        },
        out_dir: {
            short: 'o',
            long: 'out-dir',
            help: 'Output directory.',
            required: true,
        },
        rows_count: {
            short: 'r',
            long: 'rows-count',
            help: 'Number of rows per INSERT statement.',
            type: 'int',
            default: '1',
        },
        total_count: {
            short: 'N',
            long: 'total-count',
            help: 'Total number of rows of the main table.',
            type: 'int',
        },
        rows_per_file: {
            short: 'R',
            long: 'rows-per-file',
            help: 'Number of rows per file.',
            type: 'int',
        },
        escape_backslash: {
            long: 'escape-backslash',
            help: 'Escape backslashes when writing a string.',
            type: 'bool',
        },
        seed: {
            short: 's',
            help: 'Random number generator seed (should have 64 hex digits).',
        },
        jobs: {
            short: 'j',
            help: 'Number of jobs to run in parallel, default to number of CPUs.',
            type: 'int',
            default: '0',
        },
        rng: {
            help: 'Random number generator engine.',
            type: $.choices(['chacha12', 'chacha20', 'hc128', 'isaac', 'isaac64', 'xorshift', 'pcg32', 'step']),
            default: 'hc128',
        },
        quiet: {
            short: 'q',
            help: 'Disable progress bar.',
            type: 'bool',
        },
        time_zone: {
            long: 'time-zone',
            help: 'Time zone used for timestamp.',
            default: 'UTC',
        },
        zoneinfo: {
            help: 'Directory containing the tz database.',
            default: '/usr/share/zoneinfo',
        },
        now: {
            help: 'Override the current timestamp (always in UTC), in the format "YYYY-mm-dd HH:MM:SS.fff".',
        },
        format: {
            short: 'f',
            help: 'Output format.',
            type: $.choices(['sql', 'csv']),
            default: 'sql',
        },
        headers: {
            help: 'Include column names or headers in the output.',
            type: 'bool',
        },
        compression: {
            short: 'c',
            help: 'Compress data output.',
            type: $.choices(['gzip', 'xz', 'zstd']),
        },
        compress_level: {
            long: 'compress-level',
            help: 'Compression level (0-9 for gzip and xz, 1-21 for zstd).',
            type: 'int',
            default: '6',
        },
        components: {
            help: 'Components to write.',
            type: $.choices(['schema', 'table', 'data'], multiple=true),
            default: 'table,data',
        },
    },
}