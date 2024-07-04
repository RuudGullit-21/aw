#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("Формула") Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ЭтоКоэффициент = Параметры.Коэффициент;
	НаличиеСпидометра = Параметры.НаличиеСпидометра;
	
	Формула.УстановитьТекст(Параметры.Формула);
	Если ЭтоКоэффициент Тогда
		Заголовок = "Коэффициент нормы """ + Параметры.ВидНормы + """";
		Элементы.ГруппаОперанды.Заголовок = "Коэффициенты";
		Элементы.ГруппаПоказатели.Видимость = Ложь;
	Иначе
		Заголовок = "Формула нормы """ + Параметры.ВидНормы + """";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПостроитьДеревоОперандов();
	ПостроитьДеревоОператоров();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ЗначениеЗаполнено(Элементы.Операторы.ТекущиеДанные.Оператор) Тогда
		ПараметрыПеретаскивания.Значение = Элементы.Операторы.ТекущиеДанные.Оператор;
	Иначе
		Выполнение = Ложь;
	КонецЕсли;         
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВставитьОперандВФормулу("Операнды");
КонецПроцедуры

&НаКлиенте
Процедура ОперандыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ПараметрыПеретаскивания.Значение = "[" + Элементы.Операнды.ТекущиеДанные.Значение + "]";
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВставитьОперандВФормулу("Показатели");
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ПараметрыПеретаскивания.Значение = "[" + Элементы.Показатели.ТекущиеДанные.Значение + "]";
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьФормулу(Команда)
	
	Если ПроверитьФормулуДоп(Формула.ПолучитьТекст(), Операнды, "Формула") Тогда
		ПоказатьПредупреждение(, НСтр("en='In formula not found errors.';ru='В формуле не обнаружено ошибок.'"),2);
	Иначе
		ПоказатьПредупреждение(, НСтр("en='There are errors in formula.';ru='В формуле обнаружены ошибки.'"),2);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если ПроверитьФормулуДоп(Формула.ПолучитьТекст(), Операнды, "Формула") Тогда
		Закрыть(Формула.ПолучитьТекст());
	Иначе
		ПоказатьПредупреждение(, НСтр("en='There are errors in formula.';ru='В формуле обнаружены ошибки.'"),2);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФормулу(Команда)
	Если ЗначениеЗаполнено(Формула.ПолучитьТекст()) Тогда
		Оповещ = Новый ОписаниеОповещения("ОчиститьФормулуЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещ, "Очистить формулу?", РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФормулуЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Формула.Очистить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВставитьОперандВФормулу(ИмяСписка)
	ВставитьТекстВФормулу("[" + Элементы[ИмяСписка].ТекущиеДанные.Значение + "]");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстДляВставки, Сдвиг = 0)
	
	СтрокаНач  = 0;
	СтрокаКон  = 0;
	КолонкаНач = 0;
	КолонкаКон = 0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	Если (КолонкаКон = КолонкаНач) И (КолонкаКон + СтрДлина(ТекстДляВставки)) > Элементы.Формула.Ширина / 8 Тогда
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
	
	Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	
	Если Не Сдвиг = 0 Тогда
		Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
		Элементы.Формула.УстановитьГраницыВыделения(СтрокаНач, КолонкаНач - Сдвиг, СтрокаКон, КолонкаКон - Сдвиг);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьФормулуДоп(Формула, Операнды, Знач Поле = "", Знач СообщениеОбОшибке = "")
	Результат = Истина;
	
	ТекстРасчета = Формула;
	//ТекстРасчета = СтрЗаменить(ТекстРасчета, "Построчно", "1 *");
	//ТекстРасчета = СтрЗаменить(ТекстРасчета, "Оборудование", "1 *");
	
	Если ЗначениеЗаполнено(ТекстРасчета) Тогда
		Для Каждого Операнд Из Операнды Цикл
			ТекстРасчета = СтрЗаменить(ТекстРасчета, "[" + Операнд.Значение + "]", " 1 ");
		КонецЦикла;
		Для Каждого ОперандГруппа Из Показатели.ПолучитьЭлементы() Цикл
			Для Каждого Операнд Из ОперандГруппа.ПолучитьЭлементы() Цикл
				ТекстРасчета = СтрЗаменить(ТекстРасчета, "[" + Операнд.Значение + "]", " 1 ");
			КонецЦикла;
		КонецЦикла;
		Попытка
			РезультатРасчета = Вычислить(ТекстРасчета);
		Исключение
			Результат = Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции // ПроверитьФормулу()

&НаСервере
Процедура ПостроитьДеревоОператоров()
	Дерево = РеквизитФормыВЗначение("Операторы");
	
	ГруппаОператоров = Дерево.Строки.Добавить();
	ГруппаОператоров.Наименование = НСтр("en='Operators';ru='Операторы'");
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "+");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/");
	ДобавитьОператор(Дерево, ГруппаОператоров, "(");
	ДобавитьОператор(Дерево, ГруппаОператоров, ")");
	
	ГруппаОператоров = Дерево.Строки.Добавить();
	ГруппаОператоров.Наименование = НСтр("en='Logical operators and constants';ru='Логические операторы и константы'");
	
	ДобавитьОператор(Дерево, ГруппаОператоров, "<");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<=");
	ДобавитьОператор(Дерево, ГруппаОператоров, ">=");
	ДобавитьОператор(Дерево, ГруппаОператоров, "=");
	ДобавитьОператор(Дерево, ГруппаОператоров, "<>");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='I';ru='И'"), " И ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Or';ru='ИЛИ'"), " ИЛИ ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='NOT';ru='НЕ'"), " НЕ ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='ИСТИНА';ru='ИСТИНА'"), " ИСТИНА ");
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='ЛОЖЬ';ru='ЛОЖЬ'"), " ЛОЖЬ ");
	
	ГруппаОператоров = Дерево.Строки.Добавить();
	ГруппаОператоров.Наименование = НСтр("en='Function';ru='Функции'");
	
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Max';ru='Максимум'"), "Макс(,)", 2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Minimum';ru='Минимум'"), "Мин(,)", 2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Round off';ru='Округление'"), "Окр(,)", 2);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='whole part';ru='Целая часть'"), "Цел()", 1);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Condition';ru='Условие'"), "?(,,)", 3);
	ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Value is filled in';ru='Значение заполнено'"), "ЗначениеЗаполнено()", 1);
	
	ЗначениеВРеквизитФормы(Дерево, "Операторы");
КонецПроцедуры

&НаСервере
Функция ДобавитьОператор(Дерево, Родитель = Неопределено, Наименование, Оператор = Неопределено, Сдвиг = 0)
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
КонецФункции

&НаСервере
Функция ДобавитьПоказатель(Дерево, Родитель = Неопределено, Наименование, Значение)
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Значение = Значение;
		
	Возврат НоваяСтрока;
КонецФункции

&НаСервере
Процедура ПостроитьДеревоОперандов()
	
	Операнды.Очистить();
	Если ЭтоКоэффициент Тогда
		Операнды.Добавить("Kсн", "Kсн (Сезонная надбавка)");
		Операнды.Добавить("Kтм", "Kтм (Температурный коэффициент)");
		Операнды.Добавить("Kтс", "Kтс (Коэффициент изменения норм топлива ТС)");
		Операнды.Добавить("Kур", "Kур (Поправка на условие работы)");
		Операнды.Добавить("Kнк", "Kнк (Надбавка на кондиционер, климат-контроль)");
	Иначе
		Если НаличиеСпидометра Тогда
			Операнды.Добавить("Hs", "Hs (Линейная норма)");
		Иначе
			Операнды.Добавить("Ht", "Ht (Норма специальная на моточас)");
		КонецЕсли;
		Операнды.Добавить("Hw", "Hw (Норма на транспортную работу)");
		Операнды.Добавить("Hg", "Hg (Норма на изменение собственного веса)");
		Операнды.Добавить("Hdt", "Hdt (Норма на простой с вкл. двигателем)");
		Операнды.Добавить("Hhl", "Hhl (Норма на ездку)");
		Операнды.Добавить("Hop", "Hop (Норма на операцию)");
		Операнды.Добавить("Hst", "Hst (Норма на запуск)");
		Операнды.Добавить("Hht", "Hht (Норма на отопитель)");
		Для Сч = 1 По 10 Цикл
			Операнды.Добавить("Hсп" + Сч, "Hсп" + Сч + " (Норма на спец. работу " + Сч + ")");
		КонецЦикла;
	КонецЕсли;
		
	Дерево = РеквизитФормыВЗначение("Показатели");
	
	ГруппаПоказателей = Дерево.Строки.Добавить();
	ГруппаПоказателей.Наименование = "Путевой лист";
	
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "S (Пробег общий)", "S");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "T (Наработка в моточасах)", "T");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Tht (Время работы отопителя)", "Tht");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "DT (Время в простое с вкл. двигателем)", "DT");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Q (Коэффициент загрузки самосвала)", "Q");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "ST (Количество запусков)", "ST");
	
	ГруппаПоказателей = Дерево.Строки.Добавить();
	ГруппаПоказателей.Наименование = "Табличная часть ""Задание""";
	
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Gгр (Вес груза)", "Gгр");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "HL (Количество ездок)", "HL");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "OP (Количество операций)", "OP");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Sгр (Пробег с грузом)", "Sгр");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "GP (Грузоподъемность ТС и всех прицепов)", "GP");
	ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Gив (Изменение веса автопоезда)", "Gив");
	                                                                                	
	Для Сч = 1 По 10 Цикл
		ДобавитьПоказатель(Дерево, ГруппаПоказателей, "Сп" + Сч + " (Количество спец. работы" + Сч + ")", "Сп" + Сч);
	КонецЦикла;
		
	ЗначениеВРеквизитФормы(Дерево, "Показатели");
	
КонецПроцедуры

#КонецОбласти
