import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Info extends StatefulWidget {
  final String title;
  final String content;
  bool show;
  Info(
      {required this.title,
      required this.content,
      required this.show,
      super.key});
  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  changeIcon() {
    if (widget.title == "Username") {
      return const Icon(Icons.person, color: Colors.orange, size: 45);
    }
    if (widget.title == "Email") {
      return const Icon(Icons.email, color: Colors.orange, size: 45);
    }
    if (widget.title == "Password") {
      return const Icon(Icons.lock_person, color: Colors.orange, size: 45);
    } else {
      return const Icon(Icons.person, color: Colors.orange, size: 45);
    }
  }

  Icon visibleIcon =
      const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 30);
  Icon hiddenIcon =
      const Icon(Icons.remove_red_eye, color: Colors.orange, size: 30);
  late Icon activeIcon = widget.show == true ? visibleIcon : hiddenIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: const Color(0xFF0F0F1E),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Colors.orange, offset: Offset(5, 5)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                changeIcon(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: VerticalDivider(
                    color: Colors.orange,
                    indent: 25,
                    endIndent: 25,
                    thickness: 3,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 200,
                      child: widget.show == true
                          ? Text(
                              widget.content,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            )
                          : Text("*" * widget.content.length,
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    widget.show = !widget.show;
                    activeIcon = widget.show == true ? visibleIcon : hiddenIcon;
                  });
                },
                child: activeIcon),
          ],
        ));
  }
}


// Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           changeIcon(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${widget.title}", style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold)),
//               SizedBox(
//                 width: 200,
//                 child: Text("${widget.content}", style: TextStyle(color: Color(0xFFAEAEB3), fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 3,)
//                 ),
//             ],
//           ),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 widget.show = !widget.show;
//                 activeIcon = widget.show == true ? visibleIcon : hiddenIcon;
//               });
//             },
//             child: activeIcon
//           ),
//         ],
//       ) 


// ListTile(
//         leading: changeIcon(),
//         title: Text("${widget.title}", style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold)),
//         subtitle: widget.show == true ? 
//                   Text("${widget.content}", style: TextStyle(color: Color(0xFFAEAEB3), fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 3,)
//                   :Text("${"*"*widget.content.length}", style: TextStyle(color: Color(0xFF6034A6), fontSize: 16, fontWeight: FontWeight.bold)),
//         trailing: IconButton(
//           onPressed: () {
//             setState(() {
//               widget.show = !widget.show;
//               activeIcon = widget.show == true ? visibleIcon : hiddenIcon;
//             });
//           },
//           icon: activeIcon
//         ),
//         isThreeLine: false,
//       ),