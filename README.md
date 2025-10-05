# notely

An AI powered note taking experience with other user experience enhancements such as setting reminders,
- Search/Filter notes
- Export notes to PDF
- Toggle theme
- Offline support with efficient data sync when network is available.


  
  [HIGH LEVEL SYSTEM DESIGN](https://github.com/user-attachments/files/22248558/notely_flutter.drawio)<mxfile host="app.diagrams.net" agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" version="28.1.2" pages="2">
  <diagram name="Page-1" id="lz82pe6hCrsPi8H9gbmI">
    <mxGraphModel dx="1863" dy="564" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" background="none" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="w79re-UmUhQcwSExPvR5-2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="w79re-UmUhQcwSExPvR5-1" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="310" y="130" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.133;entryY=1;entryDx=0;entryDy=0;entryPerimeter=0;" parent="1" source="w79re-UmUhQcwSExPvR5-1" target="aVKE7FFwwPZxZuNJ2EgV-4" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="210" y="400" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-3" value="Not a New User" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" parent="aVKE7FFwwPZxZuNJ2EgV-1" vertex="1" connectable="0">
          <mxGeometry x="-0.1268" y="-3" relative="1" as="geometry">
            <mxPoint x="-27" as="offset" />
          </mxGeometry>
        </mxCell>
        <mxCell id="w79re-UmUhQcwSExPvR5-1" value="NEW USER" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#6a00ff;fontColor=#ffffff;strokeColor=#3700CC;" parent="1" vertex="1">
          <mxGeometry x="150" y="100" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-5" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="w79re-UmUhQcwSExPvR5-3" target="aVKE7FFwwPZxZuNJ2EgV-4" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="w79re-UmUhQcwSExPvR5-3" value="SIGN UP" style="rounded=0;whiteSpace=wrap;html=1;" parent="1" vertex="1">
          <mxGeometry x="320" y="90" width="140" height="60" as="geometry" />
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-4" value="LOGIN" style="whiteSpace=wrap;html=1;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="580" y="90" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-6" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="aVKE7FFwwPZxZuNJ2EgV-4" edge="1" target="B3S1ScT7315iu0NiolMc-6">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="610" y="340" as="targetPoint" />
            <Array as="points">
              <mxPoint x="660" y="245" />
              <mxPoint x="611" y="245" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-8" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="aVKE7FFwwPZxZuNJ2EgV-4" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="730" y="200" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="240" y="410" as="targetPoint" />
            <mxPoint x="600" y="321" as="sourcePoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-9" value="Persist Login Data" style="ellipse;whiteSpace=wrap;html=1;fillColor=#0050ef;fontColor=#ffffff;strokeColor=#001DBC;" parent="1" vertex="1">
          <mxGeometry x="730" y="130" width="60" height="90" as="geometry" />
        </mxCell>
        <mxCell id="aVKE7FFwwPZxZuNJ2EgV-10" value="Text" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" parent="1" vertex="1">
          <mxGeometry x="-665" y="108" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-4" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="IEAWJydqW6eTd3f90BY2-1" target="IEAWJydqW6eTd3f90BY2-3" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-10" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="IEAWJydqW6eTd3f90BY2-1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="90" y="370" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-16" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="IEAWJydqW6eTd3f90BY2-1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="220" y="690" as="targetPoint" />
            <Array as="points">
              <mxPoint x="190" y="595" />
              <mxPoint x="221" y="595" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-19" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="IEAWJydqW6eTd3f90BY2-1" target="B3S1ScT7315iu0NiolMc-18">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-1" value="HOME SCREEN" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#6a00ff;fontColor=#ffffff;strokeColor=#3700CC;" parent="1" vertex="1">
          <mxGeometry x="150" y="400" width="170" height="100" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-6" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="IEAWJydqW6eTd3f90BY2-3" target="IEAWJydqW6eTd3f90BY2-5" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-3" value="CREATE NOTES&lt;br&gt;*Add Reminder" style="whiteSpace=wrap;html=1;rounded=1;fillColor=#6a00ff;fontColor=#ffffff;strokeColor=#3700CC;" parent="1" vertex="1">
          <mxGeometry x="430" y="390" width="130" height="60" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-5" value="ViewModel" style="ellipse;whiteSpace=wrap;html=1;rounded=1;fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;" parent="1" vertex="1">
          <mxGeometry x="455" y="540" width="80" height="80" as="geometry" />
        </mxCell>
        <mxCell id="IEAWJydqW6eTd3f90BY2-7" value="Notes&lt;br&gt;Repository" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#0050ef;fontColor=#ffffff;strokeColor=#001DBC;" parent="1" vertex="1">
          <mxGeometry x="630" y="520" width="80" height="80" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;entryX=0.075;entryY=0.65;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="IEAWJydqW6eTd3f90BY2-5" target="IEAWJydqW6eTd3f90BY2-7">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-6" value="GENERATE &lt;br&gt;UNIQUE ID&amp;nbsp;" style="ellipse;shape=cloud;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="600" y="320" width="120" height="80" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-11" value="SEARCH NOTES" style="rhombus;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="50" y="290" width="80" height="80" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-14" value="" style="shape=flexArrow;endArrow=classic;startArrow=classic;html=1;rounded=0;" edge="1" parent="1">
          <mxGeometry width="100" height="100" relative="1" as="geometry">
            <mxPoint x="50" y="560" as="sourcePoint" />
            <mxPoint x="150" y="460" as="targetPoint" />
            <Array as="points">
              <mxPoint x="80" y="530" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-15" value="DELETE NOTES" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e51400;fontColor=#ffffff;strokeColor=#B20000;" vertex="1" parent="1">
          <mxGeometry x="-80" y="530" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-24" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="B3S1ScT7315iu0NiolMc-18" target="B3S1ScT7315iu0NiolMc-23">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-18" value="NOTE DETAILS" style="rhombus;whiteSpace=wrap;html=1;fillColor=#6a00ff;strokeColor=#3700CC;fontColor=#ffffff;rounded=1;" vertex="1" parent="1">
          <mxGeometry x="300" y="580" width="80" height="80" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-22" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="B3S1ScT7315iu0NiolMc-20" target="B3S1ScT7315iu0NiolMc-21">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-20" value="MORE BUTTON, WITH &lt;br&gt;DROPDOWN" style="ellipse;shape=cloud;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="130" y="680" width="150" height="80" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-21" value="1. GENERATE NOTES &lt;br&gt;WITH AI&lt;div&gt;2. TOGGLE &lt;br&gt;THEME&lt;/div&gt;&lt;div&gt;3. SETTINGS&lt;/div&gt;" style="shape=trapezoid;perimeter=trapezoidPerimeter;whiteSpace=wrap;html=1;fixedSize=1;fillColor=#60a917;fontColor=#ffffff;strokeColor=#2D7600;" vertex="1" parent="1">
          <mxGeometry x="-140" y="670" width="220" height="130" as="geometry" />
        </mxCell>
        <mxCell id="B3S1ScT7315iu0NiolMc-23" value="UPDATE NOTES" style="shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=none;strokeColor=default;fontColor=default;rounded=1;gradientColor=default;shadow=0;sketch=1;curveFitting=1;jiggle=2;" vertex="1" parent="1">
          <mxGeometry x="320" y="750" width="120" height="90" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
  <diagram name="Copy of Page-1" id="R2h401jY6dY9TtQFVQol">
    <mxGraphModel dx="1636" dy="564" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="eZAkOEMwmi-a_ol2o1sn-0" />
        <mxCell id="eZAkOEMwmi-a_ol2o1sn-1" parent="eZAkOEMwmi-a_ol2o1sn-0" />
        <mxCell id="eZAkOEMwmi-a_ol2o1sn-13" value="Text" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" parent="eZAkOEMwmi-a_ol2o1sn-1" vertex="1">
          <mxGeometry x="-665" y="108" width="50" height="30" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>

## Onboarding UI
<img width="290" height="629" alt="Screenshot 2025-09-10 at 07 16 25" src="https://github.com/user-attachments/assets/7ae88db8-55d2-46cf-95da-04d6158415fe" />



<img width="290" height="629" alt="Screenshot 2025-09-10 at 07 16 20" src="https://github.com/user-attachments/assets/de130966-6221-4386-9075-923f80dcfd0d" />



<img width="290" height="629" alt="Screenshot 2025-09-10 at 07 17 01" src="https://github.com/user-attachments/assets/069eadb2-9961-41b3-8c6c-34c260d4035d" />


<img width="290" height="629" alt="Screenshot 2025-09-10 at 07 16 40" src="https://github.com/user-attachments/assets/187fa879-2fd0-44a6-aaa5-f3b35244806e" />




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)


