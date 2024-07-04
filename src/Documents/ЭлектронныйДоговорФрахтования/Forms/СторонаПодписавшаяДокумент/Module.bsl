&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщееПолеВводаИНННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("РежимВыбора",Истина);

	ОбработкаВыбора = Новый ОписаниеОповещения("ПодборИНН_Завершение", ЭтотОбъект);

	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыВыбора,
	        ЭтотОбъект, , , , ОбработкаВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ПодборИНН_Завершение(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение <> Неопределено Тогда  
		ОбщееПолеВводаИНН = ИННКонтрагента(Значение);
		ОбменСГИСЭПДКлиент.ЗаполнениеРеквизитовИзОбщегоПоляВвода(Элементы.ОбщееПолеВводаИНН, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИННКонтрагента(Контрагент)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ИНН");
	
КонецФункции


&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

&НаКлиенте
Процедура ДобавлениеПоляВвода_Подключаемый(Команда)
	
	ИмяТаблицыИПоля = СтрЗаменить(Команда.Имя, "ДобавлениеПоляВвода", "");
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(ИмяТаблицыИПоля, "__");
	
	ДобавлениеПоляВводаСервер(МассивЧастей[0], МассивЧастей[1]);
	
КонецПроцедуры

&НаСервере
Процедура ДобавлениеПоляВводаСервер(ИмяТаблицы, ИмяПоля)
	
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, ИмяТаблицы, ИмяПоля, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщееПолеВводаИННПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиент.ЗаполнениеРеквизитовИзОбщегоПоляВвода(Элемент, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РФИлиНетПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеФормы(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры
