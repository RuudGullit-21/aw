
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ВидПоказателей") Тогда
		Возврат;
	КонецЕсли;

	ВидПоказателей = Параметры.ВидПоказателей;
	ОбновитьДеревоНовыхЭлементов();

	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БыстрыйПоискНовыхПриИзменении(Элемент)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаОтчета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаОтчета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискСохранненыхПриИзменении(Элемент)

	ОбновитьДеревоСохраненныхЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоВидуОтчетаПриИзменении(Элемент)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоНовыхЭлементов

&НаКлиенте
Процедура ДеревоНовыхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСохраненныхЭлементов

&НаКлиенте
Процедура ДеревоСохраненныхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиНовыйЭлемент(Команда)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ЭлементыВидаОтчета.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ЭлементыВидаОтчета.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСохраненныйЭлемент(Команда)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораЭлементаОтчета()
	
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВидЭлемента)
			ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОбработкаВыбораЭлементаОтчетаЗавершение", ЭтотОбъект), НСтр("en='Элемент не может быть выбран!';ru='Элемент не может быть выбран!'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ЭлементОтчета,ВидЭлемента,НаименованиеДляПечати");
	Результат.ВидЭлемента = ТекущиеДанные.ВидЭлемента;
	Результат.НаименованиеДляПечати = ТекущиеДанные.НаименованиеДляПечати;
	Если ТекущиеДанные.Свойство("ЭтоСвязанный") Тогда
		Результат.Вставить("СвязанныйЭлемент", ТекущиеДанные.СвязанныйЭлемент);
		Результат.Вставить("ЭтоСвязанный", Истина);
	Иначе
		Результат.Вставить("ЭлементОтчета", ТекущиеДанные.ЭлементВидаОтчетности);
		Результат.Вставить("ЭтоСвязанный", Ложь);
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЭлементаОтчетаЗавершение(ДополнительныеПараметры) Экспорт
	Заглушка = Истина;
КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоНовыхЭлементов()
	
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискНовых;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоНовыхЭлементов(ЭтотОбъект, ПараметрыДерева);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСохраненныхЭлементов()

	ОбновитьДеревоСохраненныхЭлементовНаСервере();
	Если ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		МеждународнаяОтчетностьКлиент.РазвернутьДеревоСохраненныхЭлеметов(ЭтотОбъект, ДеревоСохраненныхЭлементов);
	КонецЕсли;

КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоСохраненныхЭлементовНаСервере()
	
	Если НЕ ЗначениеЗаполнено(БыстрыйПоискСохраненных)
		И НЕ ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		СохраненныеЭлементы = ДеревоСохраненныхЭлементов.ПолучитьЭлементы();
		СохраненныеЭлементы.Очистить();
		Возврат;
	КонецЕсли;
	
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ИмяЭлементаДерева = "ДеревоСохраненныхЭлементов";
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.ФильтрПоВидуОтчета = ФильтрПоВидуОтчета;
	//ПараметрыДерева.ТекущийВидОтчета = Объект.Ссылка;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискСохраненных;
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоСохраненныхЭлементов(ЭтотОбъект, ПараметрыДерева);

КонецПроцедуры

#КонецОбласти
