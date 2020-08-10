<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 상세내용" />
<%@ include file="../part/head.jspf"%>







<div class="table-box con">
	<table>
		<colgroup>
			<col width="50" />
			<col width="200" />
		</colgroup>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${article.id }</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${article.regDate }</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${article.extra.writer}</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td>${article.hit}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${article.title }</td>

			</tr>
			<tr>
				<th>내용</th>
				<td>${article.body }</td>
			</tr>
		</tbody>
	</table>
	<div class="button">
		<div class="back">
			<input type="button" onclick="location.href='../article/list'"
				value="뒤로가기" />
		</div>

		<div class="modifyAndDelete">
			<input type="button"
				onclick="location.href='../article/modify?id=${article.id}'"
				value="수정" /> <input type="button"
				onclick="location.href='../article/delete?id=${article.id}'"
				value="삭제" />
		</div>
		<div class="move-button">
			<c:if test="${beforeId > 0}">
				<input class="before" value="이전글" type="button"
					onclick="location.href='detail?id=${beforeId}'">
			</c:if>
			<c:if test="${afterId != -1}">
				<input class="after" value="다음글" type="button"
					onclick="location.href='detail?id=${afterId}'">
			</c:if>

		</div>
	</div>
</div>
<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

	<script>

	
	function ArticleWriteReplyFrom__submit(form) {
		form.body.value = form.body.value.trim();
		if ( form.body.value.length == 0 ) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}

		// Ajax화 시작
		$.post(	'./doWriteReplyAjax',   // 기존 form 의 action을 입력해주고 전송할 데이터를 입력해준다.
			{	
				articleId : ${param.id},
				body: form.body.value
				// ajax: true  만약 post를 ./doWriteReplyAjax  Ajax를 붙이지 않는 경우 이렇게 ajax true를 날려주는게 좋다. 
			},
			function(data) {
				form.body.focus();
			},
			'json' // 필수 ( data 객체를 자바스크립트로 다루겠다는 의미)
		);
		form.body.value = '';
		// body 를 전송하고 원문을 비워준다. 그래야 댓글창으로 돌아왔을 때, 빈칸으로 입력 가능하다!
	}
</script>
	<!-- <form method="POST" class="form1" action="./doWriteReply"  Ajax화로 method와 action이 의미없어짐 -->
	<!-- Ajax화로 form은 이제 발송용으로 사용되지 않는다. -->
	<form class="form1 table-box con"
		onsubmit="ArticleWriteReplyFrom__submit(this); return false;">
		<table>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea class="height-100px" placeholder="내용을 입력해주세요."
								name="body" maxlength="300" autofocus></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>작성</th>
					<td><input type="submit" value="작성" /></td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>

<h2 class="con">댓글 리스트</h2>


<!-- 		class="loading-none" 의미 : 로딩 중일 때 안보여야 하는 버튼 -->
<!-- 수정, 삭제 버튼에서 테스트 할 때 버튼 클릭할 때마다 맨 위로 이동하는 것을 onclick="return false;"로 잠시 막을 수 있다. -->
<div class="template-box template-box-1">
	<table border="1">
		<tbody>
			<tr data-article-reply-id="{$번호}">
				<td>{$번호}</td>
				<td>{$날짜}</td>
				<td>{$작성자}</td>
				<td>
					<div class="reply-body-text modify-mode-none">{$내용}</div>
					<div class="modify-mode-block">
						<!-- 						Ajax로 할거기 때문에 페이지 이동을 막아준다. 함수명만 submit, 전송은 ajax -->
						<form
							onsubmit="ArticleReply__submitModifyReplyForm(this); return false;">
							<textarea name="body" class="height-100px">{$내용}</textarea>
							<br /> <input class="loading-none" type="submit" value="수정" />
						</form>
					</div>
				</td>
				<td>
				<span class="loading-delete-inline">삭제중입니다...</span>
				 <a	class="loading-none" href="#"onclick="if ( confirm('정말 삭제하시겠습니까?')) { ArticleReply__delete(this); } return false;">삭제</a>
					<a class="loading-none modify-mode-none" href="#"
					onclick="ArticleReply__enableModifyMode(this); return false;">수정</a>
					<a class="loading-none modify-mode-inline" href="#"
					onclick="ArticleReply__disableModifyMode(this); return false;">수정취소</a>
				</td>
			</tr>
		</tbody>
	</table>
</div>







<div class="article-reply-list-box table-box con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
			<col width="200" />
			<col width="600" />
			<col width="150" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>작성자</th>
				<th>내용</th>
				<th>비고</th>

			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>


<script>

/* function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
} */

var ArticleReplyList__$box = $('.article-reply-list-box');
var ArticleReplyList__$tbody = ArticleReplyList__$box.find('tbody');
var ArticleReplyList__lastLodedId = 0;

function ArticleReplyList__loadMore() {
	$.get('getForPrintArticleRepliesRs',{   // get : select 하는 것.
			id : param.id, //${param.id}, head에 구워?놓았기 때문에 중괄호 없이 사용 가능
			from : ArticleReplyList__lastLodedId + 1 
		}, function(data) {
			if ( data.body.articleReplies && data.body.articleReplies.length > 0 ) {
				ArticleReplyList__lastLodedId = data.body.articleReplies[data.body.articleReplies.length - 1].id;
				ArticleReplyList__drawReplies(data.body.articleReplies);
			}
			
			setTimeout(ArticleReplyList__loadMore, 1000);
		}, 'json');
	}


function ArticleReplyList__drawReplies(articleReplies) {
	for ( var i = 0; i < articleReplies.length; i++ ) {
		var articleReply = articleReplies[i];
		ArticleReplyList__drawReply(articleReply);
	}
}




function ArticleReplyList__drawReply(articleReply) {

	var html = '';
	
	html += '<tr data-id="' + articleReply.id + '">';
	html += '<td>' + articleReply.id + '</td>';
	html += '<td>' + articleReply.regDate + '</td>';
	html += '<td>' + articleReply.extra.writer + '</td>';
	html += '<td>' + articleReply.body + '</td>';
	html += '<td><span class="loading-delete-inline">삭제중입니다...</span>';
	html += '<button class="loading-none" onclick="ArticleReply__delete(this);">삭제</button></td>';
	html += '</tr>';
				

	
	ArticleReplyList__$tbody.prepend(html);
	
}	

ArticleReplyList__loadMore();


function ArticleReply__enableModifyMode(obj) {
	var $clickedBtn = $(obj);
	var $tr = $clickedBtn.closest('tr');

	var $replyBodyText = $tr.find('.reply-body-text');
	var $textarea = $tr.find('form textarea');

	$textarea.val($replyBodyText.text().trim());


	$tr.attr('data-modify-mode', 'Y');

	
}

function ArticleReply__disableModifyMode(obj) {
	
	var $clickedBtn = $(obj);
	var $tr = $clickedBtn.closest('tr');

	$tr.attr('data-modify-mode', 'N');
		
}




function ArticleReply__submitModifyReplyForm(form) {

	var $tr = $(form).closest('tr');
	form.body.value = form.body.value.trim();

	if ( form.body.value.length == 0 ) {
		alert('댓글내용을 입력 해주세요.');
		form.body.focus();

		return false;
	}

	var replyId = parseInt($tr.attr('data-article-reply-id'));
	var body = form.body.value;

	$tr.attr('data-loading', 'Y');
	$tr.attr('data-loading-modify', 'Y');

	

	$.post('./doModifyReplyAjax', {
			id: replyId,
			body: body
		}, function(data) {
			$tr.attr('data-loading', 'N');
			$tr.attr('data-loading-modify', 'N');

			
			ArticleReply__disableModifyMode(form);  

			var $replyBodyText = $tr.find('.reply-body-text');
			var $textarea = $tr.find('form textarea');

			$replyBodyText.text($textarea.val());

			// 아래는 회원 기능이 없기 때문에 삭제할 수 없어서 위에 만들어버림
			if ( data.resultCode.substr(0, 2) == 'S-' ) {
				
				ArticleReply__disableModifyMode(form); 

				var $replyBodyText = $tr.find('.reply-body-text');
				var $textarea = $tr.find('form textarea');

				$replyBodyText.text($textarea.val());
			}
	 		
			else {
				if ( data.msg ) {
					alert(data.msg);
				}
			}
		}
	);



	
}






// (obj) a태그를 조종할 수 있는 리모콘 버튼이다.
function ArticleReply__delete(obj) {
	var $clickedBtn = $(obj);  // obj 버튼을 -> $(obj); 이런식으로 만들어서 var에 담으면? 관리가 편해진다.
	// $clickedBtn : 교장 ( 교장은 학생을 관리한다.)

	//$clickedBtn.remove();  이것을 할게 아니라 예시만 들어주시고 삭제하셨음.
	// $clickedBtn이 관리하고 있는 학생은 a태그(삭제) 이다. 해당 a태그에서 함수 호출하고 this 자신을 넘겼기 때문에.

	// parent 필요량 만큼 붙여주기 귀찮
	//var $tr = $clickedBtn.parent().parent(); // a태그의 부모_td의 부모_tr !!!!
	
	var $tr = $clickedBtn.closest('tr'); // 가장 가까운 조상 중에서 tr 가져와라.
	
	//$tr.remove();

	var replyId = parseInt($tr.attr('data-id'));

	$tr.attr('data-loading', 'Y');
	$tr.attr('data-loading-delete', 'Y');
	
	$.post(
		'./doDeleteReplyAjax',  //편지 받는 사람
		{
			id: replyId
		},
		function(data) { // 답장을 받았을 때 내가 해야 하는 행동.
			$tr.attr('data-loading', 'N');
			$tr.attr('data-loading-delete', 'N');

			// 아래는 회원 기능이 없기 때문에 삭제할 수 없어서 위에 만들어버림
			if ( data.resultCode.substr(0, 2) == 'S-' ) {
				
				$tr.remove();  // 아작스 실패할 수도 있으니까 $tr.attr 다음에 remove! 성공한다면 !
				 
			}
	 		
			else {
				if ( data.msg ) {
					alert(data.msg);
				}
			}
		}, 'json' );
	
}



</script>



<style>
.table-box {
	
}

.table-box  .button {
	display: flex;
}

.table-box .button .back {
	margin-left: 30px;
}

.table-box  .button .modifyAndDelete {
	margin-right: 0;
	margin-left: auto;
	width: 100px;
	justify-content: space-around;
}

a:hover {
	color: red;
}

textarea {
	width: 100%;
}

.article-reply-list-box tr .loading-delete-inline {
	display: none;
	font-weight: bold;
	color: red;
}

.article-reply-list-box tr[data-loading="Y"] .loading-none {
	display: none;
}

/* loading이면서 delete-loading 일 때 */
.article-reply-list-box tr[data-loading="Y"][data-loading-delete="Y"] .loading-delete-inline
	{
	display: inline;
}

.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-none {
	display: none;
}

.article-reply-list-box tr .modify-mode-inline {
	display: none;
}

.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-inline {
	display: inline;
}

.article-reply-list-box tr .modify-mode-block {
	display: none;
}

.article-reply-list-box tr[data-modify-mode="Y"] .modify-mode-block {
	display: block;
}
</style>




<%@ include file="../part/foot.jspf"%>
