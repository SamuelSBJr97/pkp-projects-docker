<?php

/**
 * @file classes/migration/upgrade/v3_4_0/I9822_ChangeUsageStatsTemporaryTablesIndexes.php
 *
 * Copyright (c) 2025 Simon Fraser University
 * Copyright (c) 2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class I9822_ChangeUsageStatsTemporaryTablesIndexes
 *
 * @brief Consider aditional columns user_agent and canonical_url for the index on temporary usage stats tables to fix/improve the removeDoubleClicks and compileUniqueClicks query.
 */

namespace APP\migration\upgrade\v3_4_0;

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use PKP\install\DowngradeNotSupportedException;

class I9822_ChangeUsageStatsTemporaryTablesIndexes extends \PKP\migration\upgrade\v3_4_0\I9822_ChangeUsageStatsTemporaryTablesIndexes
{
    /**
     * Run the migration.
     */
    public function up(): void
    {
        Schema::table('usage_stats_unique_title_investigations_temporary_records', function (Blueprint $table) {
            if (Schema::hasIndex('usage_stats_unique_title_investigations_temporary_records', 'usti_load_id_context_id_ip')) {
                $table->dropIndex('usti_load_id_context_id_ip');
            }
            if (!Schema::hasIndex('usage_stats_unique_title_investigations_temporary_records', 'usti_load_id_context_id_ip_ua')) {
                $table->index(['load_id', 'context_id', 'ip', 'user_agent'], 'usti_load_id_context_id_ip_ua');
            }
        });
        Schema::table('usage_stats_unique_title_requests_temporary_records', function (Blueprint $table) {
            if (Schema::hasIndex('usage_stats_unique_title_requests_temporary_records', 'ustr_load_id_context_id_ip')) {
                $table->dropIndex('ustr_load_id_context_id_ip');
            }
            if (!Schema::hasIndex('usage_stats_unique_title_requests_temporary_records', 'ustr_load_id_context_id_ip_ua')) {
                $table->index(['load_id', 'context_id', 'ip', 'user_agent'], 'ustr_load_id_context_id_ip_ua');
            }
        });
        parent::up();
    }

    /**
     * Reverse the downgrades
     *
     * @throws DowngradeNotSupportedException
     */
    public function down(): void
    {
        throw new DowngradeNotSupportedException();
    }
}
