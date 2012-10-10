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


package HSDB45::Eval::Question::ResponseGroup::SmallGroupInstructor;

use base qw(HSDB45::Eval::Question::ResponseGroup);

sub add_response {
    my $self = shift;
    my @valids = grep { ref $_ && $_->isa ('HSDB45::Eval::Question::Response') } @_;
    for (@valids) { $self->{-responses}{$_->field_value('user_code')} = $_ }
}


1;
