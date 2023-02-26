// ? Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: EdgeInsets.only(
//                                                           left: 20),
//                                                       child: Chip(label: Text("MA Abs Series"),
//                                                       deleteIcon: Icon(Icons.close_sharp, size: 16,),onDeleted: (){},)
//                                                     ),
//                                                     TextFormField(
//                                                       maxLines: null,
//                                                       autofocus: true,
//                                                       obscureText: false,
//                                                       decoration:
//                                                           InputDecoration(
//                                                         /* content padding을 20이상 잡아두지 않으면,
//                                                             한글 입력 시 텍스트가 위아래로 움직이는 오류 발생 */
//                                                         contentPadding:
//                                                             EdgeInsets.all(20),
//                                                         hintText:
//                                                             '동작 수행 시 특이사항을 남겨보세요.',
//                                                         hintStyle: TextStyle(
//                                                             color:
//                                                                 Palette.gray99,
//                                                             fontSize: 14),
//                                                         border:
//                                                             InputBorder.none,
//                                                       ),
//                                                       style: TextStyle(
//                                                           color: Palette.gray00,
//                                                           fontSize: 14),
//                                                       /* validator:
//                                                                 _model.textControllerValidator.asValidator(context), */
//                                                     )
//                                                   ],
//                                                 ),
//                                               )