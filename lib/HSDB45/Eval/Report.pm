# Copyright 2012 Tufts University
#
# Licensed under the Educational Community License, Version 1.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.opensource.org/licenses/ecl1.php
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package HSDB45::Eval::Report;

use strict;

use HSDB45::Eval;
use HSDB45::Eval::Results;
use HSDB45::Eval::Question;
use HSDB45::Eval::Question::Results;

sub quick_report {
	my $eval = shift;
	my $evaluatee_id = shift;
	my $teaching_site_id = shift;

	my $results = HSDB45::Eval::Results->new($eval, $evaluatee_id, $teaching_site_id);

	print '<ol>';
	foreach my $question ($eval->questions()) {
		my $body = $question->body();
		my $question_type = $body->question_type();
		next if ($question_type eq 'Title');
		print '<li>' unless ($question_type eq 'Instruction');
		printf('<p>%s</p>', $body->question_text());
		next if ($question_type eq 'Instruction');
		print_legend($body) if ($question_type eq 'NumericRating');
		my $question_results = HSDB45::Eval::Question::Results->new($question, $results);
		if ($question_results->isa('HSDB45::Eval::Question::Results::Textual')) {
			print_responses($question_results);
		} else {
			print_statistics($question_results);
		}
		print '</li>';
	}
	print '</ol>';
}

sub print_responses() {
	my $question_results = shift;

	print '<ul>';
	foreach my $response ($question_results->responses()) {
		printf('<li>%s', $response->response()) if ($response->response());
	}
	print '</ul>';
}

sub print_legend() {
	my $body = shift;

	printf('<p><b>High:</b> %s<br>', $body->high_text());
	printf('<b>Low:</b> %s</p>', $body->low_text());
}

sub print_statistics() {
	my $question_results = shift;

	my $statistics = $question_results->statistics();

	if ($question_results->is_numeric()) {
		printf('<p><b>N:</b> %d, <b>NA:</b> %d<br>', $statistics->count(), $statistics->na_count());
		printf('<b>Mean:</b> %.2f, <b>Std Dev:</b> %.2f<br>', $statistics->mean(), $statistics->standard_deviation());
		printf('<b>Median:</b> %.2f, <b>25%%:</b> %.2f, <b>75%%:</b> %.2f<br>', $statistics->median(), $statistics->median25(), $statistics->median75());
		printf('<b>Mode:</b> %.2f</p>', $statistics->mode());
	}

if ($question_results->is_binnable()|| $question_results->is_multibinnable()) {
		my $histogram = $statistics->histogram();
		print '<table border="1" cellspacing="0">';
		print '<caption><b>Frequency:</b></caption>';
		print '<tr><th align ="center">Choice</th><th align="center">Total</th></tr>';
		foreach my $bin ($histogram->bins()) {
			printf('<tr><td align ="center">%s</td><td align="center">%d</td></tr>', $bin, $histogram->bin_count($bin));
		}
		print '</table>';
}
}

1;
__END__
