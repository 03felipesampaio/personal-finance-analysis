select
    pattern
from
    {{ source('bronze', 'transfer_between_accounts_patterns') }}