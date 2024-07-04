&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЭтоОднострочныйВвод = Параметры.Свойство("ОднострочныйВвод");
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументПередачиГрузаНаименованиеПриИзменении(Элемент)
	
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ИдентификаторСтроки = Неопределено;	
	Иначе	
		ИдентификаторСтроки = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные.ИдентификаторСтроки;
	КонецЕсли;
	
	ИзменитьОформлениеКнопок(Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки",
		"ЗаполнитьТитулПеревозчикаЗаменыТСДокументПередачиГрузаРеквизитыСторон", ИдентификаторСтроки));
	
КонецПроцедуры

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
Процедура ТитулПеревозчикаЗаменыТранспортныеСредстваПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулПеревозчикаЗаменыТранспортноеСредствоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Это второй параметр нажатия гиперссылки
	Если ДанныеВыбора = Истина Тогда
		ДанныеВыбора = Ложь;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные;
	// Однострочный ввод
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ТитулПеревозчикаЗаменыТранспортныеСредства[0];
	КонецЕсли;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулПеревозчикаЗаменыТранспортноеСредствоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные;
	// Однострочный ввод
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ТитулПеревозчикаЗаменыТранспортныеСредства[0];
	КонецЕсли;
	
	ЗначениеРеквизита = ТекущиеДанные.ХранимыеДанныеТитулПеревозчикаЗаменыТранспортноеСредство;
	Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		ВходящийКонтекст = Новый Структура;
		ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
		ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
		ВходящийКонтекст.Вставить("ГруппаДанных", СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));
		ВходящийКонтекст.Вставить("ТекущиеДанные", ТекущиеДанные);
		ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(ЗначениеРеквизита, ВходящийКонтекст);	
	Иначе
		ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеЭлементовФормы(ЭтотОбъект, СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулПеревозчикаЗаменыТранспортноеСредствоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ГруппаДанных = СтрЗаменить(Элемент.Имя, "ХранимыеДанные", "");
	ПараметрыПолученияДанных.Отбор = ОбменСГИСЭПДКлиент.ПолучитьОтборХранимыхДанных(ЭтотОбъект, ЭтотОбъект, ГруппаДанных);
	ПараметрыПолученияДанных.СпособПоискаСтроки = ПредопределенноеЗначение("СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулПеревозчикаЗаменыПрицепыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Это второй параметр нажатия гиперссылки
	Если ДанныеВыбора = Истина Тогда
		ДанныеВыбора = Ложь;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные;
	// Однострочный ввод
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ТитулПеревозчикаЗаменыТранспортныеСредства[0];
	КонецЕсли;
	
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулПеревозчикаЗаменыТСДокументПередачиГрузаРеквизитыСторонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Это второй параметр нажатия гиперссылки
	Если ДанныеВыбора = Истина Тогда
		ДанныеВыбора = Ложь;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные;
	// Однострочный ввод
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ТитулПеревозчикаЗаменыТранспортныеСредства[0];
	КонецЕсли;
	
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулПеревозчикаЗаменыСведенияОСпециальныхУсловияхДвиженияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Это второй параметр нажатия гиперссылки
	Если ДанныеВыбора = Истина Тогда
		ДанныеВыбора = Ложь;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные;
	// Однострочный ввод
	Если Элементы.ТитулПеревозчикаЗаменыТранспортныеСредства.ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = ТитулПеревозчикаЗаменыТранспортныеСредства[0];
	КонецЕсли;
	
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаЗаменыТранспортныеСредстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ЗаполнитьТитулПеревозчикаЗаменыПрицепы" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	Если Поле.Имя = "ЗаполнитьТитулПеревозчикаЗаменыТСДокументПередачиГрузаРеквизитыСторон" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	Если Поле.Имя = "ЗаполнитьТитулПеревозчикаЗаменыСведенияОСпециальныхУсловияхДвижения" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаЗаменыТранспортныеСредстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаЗаменыТранспортныеСредстваПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если ЭтоОднострочныйВвод
		И ТитулПеревозчикаЗаменыТранспортныеСредства.Количество() = 1 Тогда
		ПоказатьПредупреждение(,"Для выбранного вида операции допускается выбор только одного транспортного средства.");
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры




&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтметитьОбязательныеНеЗаполненныеЭлементыФормы" Тогда
		Если УникальныйИдентификатор <> Параметр Тогда
			Возврат;
		КонецЕсли;
		ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр);
	ИначеЕсли ИмяСобытия = "ИзменитьОформлениеКнопокФормы" Тогда
		Если УникальныйИдентификатор <> Параметр.УникальныйИдентификаторОбновляемойФормы Тогда
			Возврат;
		КонецЕсли;
		ИзменитьОформлениеКнопок(Параметр);	 
	КонецЕсли;
	
КонецПроцедуры

#Область ОбъектыОбязательныеДляЗаполнения

&НаКлиенте
Процедура ИзменитьОформлениеКнопок(Параметр) Экспорт
	
	Если Не ЭтотОбъект.НачальноеОформлениеВыполнено Тогда
		ЭтотОбъект.ТребуетсяДополнительноеОформлениеКнопок = Истина;
		Если ЭтотОбъект.СтруктураДополнительногоОформленияКнопок <> Неопределено Тогда
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = 
				Новый Структура("ИмяКнопки, ИдентификаторСтроки");
		Иначе
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = Параметр;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураСТекущимиДанными = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	СтруктураДанныхОбъекта = ОбменСГИСЭПДКлиентСервер.ПолучитьСериализуемыйОбъектСДаннымиДокумента(ЭтотОбъект);
	СтруктураСДаннымиФормыДляОформленияКнопок = ОбменСГИСЭПДКлиентСервер.СтруктураСДаннымиФормыДляОформленияКнопок(ЭтотОбъект);
	
	Результат = ИзменитьОформлениеКнопокНаСервере(СтруктураСТекущимиДанными,
		Параметр.ИмяКнопки,
		Параметр.ИдентификаторСтроки,
		СтруктураДанныхОбъекта,
		СтруктураСДаннымиФормыДляОформленияКнопок);
		
	Если Результат.Успешно Тогда
		ЭтотОбъект.АдресДереваСоответствийИтаблицыКнопок = Результат.НовыйАдресВХранилище;	
		МассивОформления = Результат.МассивОформления;
		ОбменСГИСЭПДКлиентСервер.ОформлениеКнопокНаФорме(ЭтотОбъект, СтруктураСТекущимиДанными, МассивОформления);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьОформлениеКнопокНаСервере(Знач СтруктураСТекущимиДанными,
	ИмяКнопки = Неопределено,
	ИдентификаторСтроки = Неопределено,
	Знач СтруктураДанныхОбъекта,
	Знач СтруктураСДаннымиФормыДляОформленияКнопок)
	
	Результат = Новый Структура("Успешно, НовыйАдресВХранилище, МассивОформления", Ложь, Неопределено, Неопределено);
	
	НовыйАдресВХранилище = ОбменСГИСЭПД.ЗапуститьИзменениеОформленияКнопок(СтруктураСДаннымиФормыДляОформленияКнопок,
		СтруктураСТекущимиДанными, ИмяКнопки, ИдентификаторСтроки, СтруктураДанныхОбъекта);
		
	СтруктураДанных = ПолучитьИзВременногоХранилища(НовыйАдресВХранилище);
	Если СтруктураДанных = Неопределено Тогда
		Возврат Результат;	
	Иначе
		Результат.Успешно = Истина;
		Результат.НовыйАдресВХранилище = НовыйАдресВХранилище;
		Результат.МассивОформления = СтруктураДанных.МассивОформления;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


&НаКлиенте
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(УникальныйИдентификаторОбновляемойФормы)
	
	ЭтотОбъект.НачальноеОформлениеВыполнено = Истина;
	
	СтруктураСТекущимиДанными = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(СтруктураСТекущимиДанными);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(Знач СтруктураСТекущимиДанными)
	
	ОбменСГИСЭПД.ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(ЭтотОбъект, СтруктураСТекущимиДанными);
	
КонецПроцедуры

#КонецОбласти